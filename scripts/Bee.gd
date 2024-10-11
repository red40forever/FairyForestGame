class_name Bee
extends Entity

var the_stupid_way: GridObjectAttributes = Resources.find("object")["item_pile"]

func get_class_name(): return "Bee"

# Bees create ItemPiles on empty tiles
func interact_with_empty_tile():
	var pile = GameManager.tilemap_manager.create_object_at_coords(the_stupid_way, grid_coordinates)
	pile.request_interaction(slot)
