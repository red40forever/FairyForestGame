class_name GridObject
extends Node2D

@export_group("Interactions")
@export_subgroup("Interface")
@export var main_sprite: CanvasItem
@export var selection_button: Button

@export_group("TypeAssignments")
@export var carryable_resources: Array[Slot.ResourceType]

@export_group("Contraints")
@export var max_storage: int

@export_group("References")
@export var slot_display: SlotDisplay

var grid_coordinates: Vector2i
var slot: Slot

var selected: bool = false
var hovered: bool = false
var is_despawned: bool = false

signal despawned

func _ready():
	position = GameManager.tilemap_manager.ground_layer.map_to_local(grid_coordinates)
	
	initialize_slot()
	
	if selection_button:
		selection_button.button_down.connect(func(): UIManager._on_grid_object_clicked(self))
		selection_button.button_up.connect(func(): UIManager._on_grid_object_released(self))
		selection_button.mouse_entered.connect(on_hover_start)
		selection_button.mouse_exited.connect(on_hover_finish)
	else:
		push_warning("GridObject '", name, "' has no hover area specified.")
	
	if slot_display:
		slot_display.displayed_slot = slot
	else:
		push_warning("GridObject '", name, "' does not have a SlotDisplay.")
	
	GameManager.day_manager.day_starting.connect(_on_day_start)
	GameManager.day_manager.day_ending.connect(_on_day_end)


func initialize_slot():
	slot = Slot.new(carryable_resources, max_storage)


# Called before day change animation, override to implement day change logic
func _on_day_end():
	pass


# Called after day change animation, override to implement day change logic
func _on_day_start():
	pass


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


func _can_recieve_resource(resource_type: Slot.ResourceType) -> bool:
	if not carryable_resources.has(resource_type):
		return false
	if slot.stored_resources.size >= max_storage:
		return false
	return true


func _can_give_resource(resource_type: Slot.ResourceType) -> bool:
	return slot.get_resource_count(resource_type) > 0


func _give_resource(resource_type: Slot.ResourceType):
	if _can_give_resource(resource_type):
		slot.remove_resource(resource_type, 1)


func _recieve_resource(resource_type: Slot.ResourceType) -> int:
	if not _can_recieve_resource(resource_type):
		return 1
	return slot.add_resource_overflow_safe(resource_type, 1)


func despawn():
	is_despawned = true
	despawned.emit()	
	queue_free()


func get_surrounding_tiles():
	return [
		grid_coordinates + Vector2i(0, -2),
		grid_coordinates + Vector2i(0, -1),
		grid_coordinates + Vector2i(1, 0),
		grid_coordinates + Vector2i(0, 1), 
		grid_coordinates + Vector2i(0, 2),
		grid_coordinates + Vector2i(-1, 1),
		grid_coordinates + Vector2i(-1, 0),
		grid_coordinates + Vector2i(-1, -1)
	]


func get_surrounding_free_and_accessible_tiles(include_occupied: bool = false):
	var surrounding_coords = get_surrounding_tiles()
	return surrounding_coords.filter(
		func(coords):
			return GameManager.tilemap_manager.is_tile_free_and_accessible(coords, include_occupied)
	)


func on_hover_start():
	hovered = true
	
	if selected:
		return
	
	if main_sprite:
		main_sprite.material.set("shader_parameter/enabled", true)
	
	# might need to make its way into intermediate class if a
	# grid objects end up lacking a slot for whatever reason
	if slot_display:
		slot_display.set_open(true)


func on_hover_finish():
	hovered = false
	
	if selected:
		return
	
	if main_sprite:
		main_sprite.material.set("shader_parameter/enabled", false)
	
	# might need to make its way into intermediate class if a
	# grid objects end up lacking a slot for whatever reason
	if slot_display:
		slot_display.set_open(false)
