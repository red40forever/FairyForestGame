class_name GridObject
extends Node2D

@export_group("Interactions")
@export_subgroup("Interface")
@export var main_sprite: CanvasItem
@export var hover_area: Area2D

var grid_coordinates: Vector2i

var selected: bool = false


func _ready():
	global_position = GameManager.tilemap_manager.ground_layer.map_to_local(grid_coordinates)
	
	if hover_area:
		hover_area.input_event.connect(on_area2d_input)
		hover_area.mouse_entered.connect(on_hover_start)
		hover_area.mouse_exited.connect(on_hover_finish)
	else:
		push_warning("GridObject '", name, "' has no hover area specified.")
	
	if !main_sprite:
		push_warning("GridObject '", name, "' has no main sprite specified.")


func on_click():
	set_selected(true)


func set_selected(new_selected: bool):
	selected = new_selected
	GameManager.player.selected_object = self
	if main_sprite:
		if selected:
			main_sprite.material.set("shader_parameter/outline_color", Color.AQUA)
		else:
			main_sprite.material.set("shader_parameter/outline_color", Color.WHITE)


func on_area2d_input(viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and !event.is_pressed():
		viewport.set_input_as_handled()
		on_click()


func on_hover_start():
	print("hovered")
	if selected: return
	if main_sprite:
		main_sprite.material.set("shader_parameter/enabled", true)


func on_hover_finish():
	print("stopped hovering")
	if selected: return
	if main_sprite:
		main_sprite.material.set("shader_parameter/enabled", false)
