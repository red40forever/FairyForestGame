class_name Bee
extends Entity


func get_class_name(): return "Bee"


func _ready() -> void:
	carryable_resources = [Slot.ResourceType.HONEY, Slot.ResourceType.POLLEN, Slot.ResourceType.SPORE]
	super()


# Bees create ItemPiles on empty tiles
func interact_with_empty_tile():
	if not slot.is_empty():
		var pile_resource = Resources.find("objects")["item_pile"]
		var pile_object = GameManager.tilemap_manager.create_object_at_coords(pile_resource, grid_coordinates)
		var result = pile_object.request_interaction(slot)
		if !result:
			pile_object.despawn()
