class_name PanCamera
extends Camera2D

@export_group("Zoom")
@export var zoom_levels: PackedInt32Array
@export var zoom_animation_time: float = 0.2

@export_group("Panning")
@export var pan_decceleration: float = 0.0

var control_mode: CameraControlMode = CameraControlMode.SELECT

var zoom_magnitude: int:
	set(value):
		return
	get:
		return zoom_levels[zoom_level_index]
var zoom_level_index: int = 0

var is_dragging: bool = false


func _ready():
	set_zoom_level(0, false)


func _process(_delta):
	if Input.is_action_just_pressed("zoom_in"):
		zoom_in()
	elif Input.is_action_just_pressed("zoom_out"):
		zoom_out()


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				is_dragging = true
			else:
				is_dragging = false
		elif event.button_index == MOUSE_BUTTON_LEFT:
			# Place object on LMB release, not press
			if event.is_pressed():
				return
			var tilemap_manager = GameManager.tilemap_manager
			var global_pos = get_global_mouse_position()
			var coords = tilemap_manager.ground_layer.local_to_map(global_pos)
			tilemap_manager.placement_helper.place_at_coords(coords)
	elif event is InputEventMouseMotion and is_dragging:
		offset -= event.relative / zoom


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


enum CameraControlMode {
	SELECT,
	PLACE
}
