class_name ItemPile
extends InteractableGridObject

var slot: Slot

const max_ground_items: int = 2
const item_display_spread: Vector2 = Vector2(10, 6)


func _ready() -> void:
	# Item pile accepts all resource types
	var accepted_types: Array[Slot.ResourceType]
	for resource_type in Slot.ResourceType:
		accepted_types.append(Slot.ResourceType[resource_type])
	
	GameManager.day_manager.day_changed.connect(_on_day_changed)
	
	slot = Slot.new(accepted_types, max_ground_items)
	slot.resource_count_updated.connect(_on_slot_resource_count_updated)


## Attempt to deposit a resource into this object's slot.
## Returns a boolean stating whether the resource was deposited successfully
func deposit(resource: Slot.ResourceType, count: int) -> bool:
	if slot.total_resource_count + count > slot.max_count:
		return false
	
	slot.add_resource(resource, count)
	
	return true


func _on_slot_resource_count_updated(resource_type: Slot.ResourceType, old_count: int, new_count: int):
	_update_displayed_resources()


func _on_day_changed(day_count: int):
	_try_create_building_with_items()


func _try_create_building_with_items():
	# Loop through every building recipe. If we have enough to craft something, we should craft it.
	var placement_helper: TilePlacementHelper = GameManager.tilemap_manager.placement_helper
	for recipe in placement_helper.building_recipes:
		# Do we have enough resources to do this recipe?
		var resource_count = slot.get_resource_count(recipe.resource)
		if resource_count >= recipe.cost:
			print("Creating building from recipe '", recipe.id, "'")
			slot.remove_resource(recipe.resource, recipe.cost)
			placement_helper.place_at_coords(recipe.building, grid_coordinates)
			queue_free()
			return
		else:
			print("We don't have enough resources to build ", recipe.id)
			print("Need: ", recipe.cost, ", Have: ", resource_count)

## Update the resource icons displayed on the tile.
func _update_displayed_resources():
	for child in get_children():
		child.queue_free()
	
	var rng = RandomNumberGenerator.new()
	rng.seed = 1
	for resource_type in slot.stored_resources:
		var resource_count = slot.get_resource_count(resource_type)
		for i in range(resource_count):
			var resource_sprite = ResourceSprite.new(resource_type)
			
			add_child(resource_sprite)
			
			resource_sprite.position = Vector2(
				rng.randi_range(-item_display_spread.x, item_display_spread.x),
				rng.randi_range(-item_display_spread.y, item_display_spread.y)
			)

func request_interaction(incoming_slot: Slot) -> bool:
	for type in incoming_slot.accepted_types:
		var resource_count = incoming_slot.get_resource_count(type)
		if resource_count == 0:
			continue
		var overflow = slot.add_resource_overflow_safe(type, resource_count)
		var exchange = slot.get_resource_count(type) - overflow
		slot.remove_resource(type, exchange)
		if exchange > 0:
			return true
	return false
