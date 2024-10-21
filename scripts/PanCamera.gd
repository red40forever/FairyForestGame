class_name PanCamera
extends Camera2D

@export_group("Zoom")
@export var zoom_levels: PackedInt32Array
@export var zoom_animation_time: float = 0.2

@export_group("Panning")
@export var pan_decceleration: float = 0.0
@export var min_coords: Vector2
@export var max_coords: Vector2

var control_mode: CameraControlMode = CameraControlMode.SELECT

var zoom_magnitude: int:
	set(value):
		return
	get:
		return zoom_levels[zoom_level_index]
var zoom_level_index: int = 0

var is_dragging: bool = false

signal tile_clicked(coordinates: Vector2i)


func _ready():
	set_zoom_level(1, false)
	
	UIManager.dialogue_started.connect(_on_dialogue_started)


func _unhandled_input(event):
	# If Dialogic is open, camera controls are disabled
	if UIManager.dialogue_open:
		return
	
	# Zoom input
	if event.is_action_pressed("zoom_in"):
		zoom_in()
	elif event.is_action_pressed("zoom_out"):
		zoom_out()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Select tile on LMB release, not press
			if event.is_pressed():
				return
			var tilemap_manager = GameManager.tilemap_manager
			var ground_layer = tilemap_manager.ground_layer
			var local_mouse_pos = ground_layer.to_local(get_global_mouse_position())
			var coords = ground_layer.local_to_map(local_mouse_pos)
			
			tile_clicked.emit(coords)
			
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				is_dragging = true
			else:
				is_dragging = false
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and is_dragging:
		offset -= event.relative / zoom
		offset.x = min(max(min_coords.x, offset.x), max_coords.x)
		offset.y = min(max(min_coords.y, offset.y), max_coords.y)
		
		get_viewport().set_input_as_handled()


func zoom_in():
	if zoom_level_index < zoom_levels.size() - 1:
		set_zoom_level(zoom_level_index + 1)


func zoom_out():
	if zoom_level_index > 0:
		set_zoom_level(zoom_level_index - 1)


func set_zoom_level(new_magnitude: int, should_animate: bool = true):
	zoom_level_index = new_magnitude
	var new_zoom = Vector2.ONE * zoom_magnitude
	
	if should_animate:
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "zoom", new_zoom, zoom_animation_time)
	else:
		zoom = new_zoom


func _on_dialogue_started():
	# Stop dragging when dialogue starts so player isn't stuck dragging on dialogue close
	is_dragging = false


enum CameraControlMode {
	SELECT,
	PLACE
}
