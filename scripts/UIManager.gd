extends Control

@onready var ui: Control
@onready var pause_menu: PauseMenu
@onready var camera: PanCamera

var dialogue_open: bool = false
var ingame: bool = false

signal dialogue_started
signal dialogue_ended

enum interactivityState {SELECTION, MOVEMENT, RESOURCE_TRANSFER}

var is_dragging: bool

func initialize	():
	ui = $"../MainScene/CanvasLayer/%UI"
	pause_menu = $"../MainScene/CanvasLayer/%UI/%PauseMenu"
	camera = $"../MainScene/Player/%Player/%Camera2D"
	
	is_dragging = false
	ingame = true
	
	Dialogic.timeline_started.connect(_on_dialogue_started)
	Dialogic.timeline_ended.connect(_on_dialogue_ended)


func deinitialize():
	ingame = false


func _unhandled_input(event):
	# If Dialogic is open, camera controls are disabled
	if (not ingame) or pause_menu.open or dialogue_open:
		return
	
	# Zoom input
	if event.is_action_pressed("zoom_in"):
		camera.zoom_in()
	elif event.is_action_pressed("zoom_out"):
		camera.zoom_out()
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Select tile on LMB release, not press
			if event.is_pressed():
				return

			var mouse_grid_pos = GameManager.tilemap_manager.global_to_grid(get_global_mouse_position())
			_on_base_tile_clicked(mouse_grid_pos)
			
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			is_dragging = event.is_pressed()
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and is_dragging:
		camera.pan(event.relative)
		get_viewport().set_input_as_handled()


func _on_dialogue_started():
	dialogue_open = true
	dialogue_started.emit()


func _on_dialogue_ended():
	dialogue_open = false
	dialogue_ended.emit()


func _on_pause():
	pass


func _on_unpause():
	pass


func _on_grid_object_clicked(target: GridObject):
	pass


func _on_base_tile_clicked(target: Vector2i):
	pass


func _on_air_clicked():
	pass
