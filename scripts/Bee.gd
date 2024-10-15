class_name Bee
extends Entity

var the_stupid_way: GridObjectAttributes = Resources.find("objects")["item_pile"]

func get_class_name(): return "Bee"

func _ready() -> void:
	carryable_resources = [Slot.ResourceType.HONEY, Slot.ResourceType.POLLEN, Slot.ResourceType.SPORE]
	super()

# Bees create ItemPiles on empty tiles
func interact_with_empty_tile():
	if not slot.is_empty():
		var pile = GameManager.tilemap_manager.create_object_at_coords(the_stupid_way, grid_coordinates)
		pile.request_interaction(slot)
