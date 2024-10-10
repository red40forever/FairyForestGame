class_name GridObject
extends Node2D

@export_group("Interactions")
@export_subgroup("Interface")
@export var main_sprite: CanvasItem
@export var selection_button: Button

var grid_coordinates: Vector2i

var selected: bool = false


func _ready():
	global_position = GameManager.tilemap_manager.ground_layer.map_to_local(grid_coordinates)
	
	if selection_button:
		selection_button.pressed.connect(on_pressed)
		selection_button.mouse_entered.connect(on_hover_start)
		selection_button.mouse_exited.connect(on_hover_finish)
	else:
		push_warning("GridObject '", name, "' has no hover area specified.")


func on_click():
	GameManager.player.selected_object = self


func set_selected(new_selected: bool):
	selected = new_selected
	
	# If we don't have a main sprite, nothing visual needs to happen
	if !main_sprite:
		return
	
	if selected:
		main_sprite.material.set("shader_parameter/outline_color", Color.AQUA)
	else:
		main_sprite.material.set("shader_parameter/outline_color", Color.WHITE)
	
	if selection_button.is_hovered():
		main_sprite.material.set("shader_parameter/enabled", true)
	else:
		main_sprite.material.set("shader_parameter/enabled", false)


func on_pressed():
	print("object handled")
	on_click()


func on_hover_start():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	
	if selected:
		return
	
	if main_sprite:
		main_sprite.material.set("shader_parameter/enabled", true)


func on_hover_finish():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	if selected:
		return
	
	if main_sprite:
		main_sprite.material.set("shader_parameter/enabled", false)
