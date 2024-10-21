class_name GridObject
extends Node2D

@export_group("Interactions")
@export_subgroup("Interface")
@export var main_sprite: CanvasItem
@export var selection_button: Button

var grid_coordinates: Vector2i

var selected: bool = false
var is_despawned: bool = false

signal clicked
signal despawned

func _ready():
	position = GameManager.tilemap_manager.ground_layer.map_to_local(grid_coordinates)
	
	if selection_button:
		selection_button.pressed.connect(on_pressed)
		selection_button.mouse_entered.connect(on_hover_start)
		selection_button.mouse_exited.connect(on_hover_finish)
	else:
		push_warning("GridObject '", name, "' has no hover area specified.")
	
	GameManager.day_manager.day_changed.connect(_on_day_changed)


# Called on day change, override to implement day change logic
func _on_day_changed():
	pass


# Overridden in inheriting classes
func on_click():
	# Select this object when clicked, or deselect if it's already selected
	if !selected:
		GameManager.player.selected_object = self
	else:
		GameManager.player.selected_object = null


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


func despawn():
	is_despawned = true
	despawned.emit()	
	queue_free()


func on_pressed():
	clicked.emit()
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
