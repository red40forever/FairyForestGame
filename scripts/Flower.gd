class_name Flower
extends ResourceTile

func _ready() -> void:
	produced_resources = [Slot.ResourceType.POLLEN]
	super()
	GameManager.day_manager.day_changed.connect(upgrade_check)


# TODO add upgrade flag when next to molehill
func upgrade_check():
	var map_pos = grid_coordinates
	var upgrade_range = [map_pos + Vector2i(0, -2), map_pos + 
	Vector2i(0, -1), map_pos + Vector2i(1, 0), map_pos + Vector2i(0, 1), 
	map_pos + Vector2i(0, 2), map_pos + Vector2i(-1, 1), map_pos + 
	Vector2i(-1, 0), map_pos + Vector2i(-1, -1)]
	# check if there is a molehill in upgrade_range
	for coords in range(upgrade_range.size()):
		var curr_obj = GameManager.tilemap_manager.get_objects_at(upgrade_range[coords])
		if curr_obj is MoleHill:
			upgrade_tier()
			break


# TODO already called on day change
func upgrade_tier():
	
	pass

func get_class_name(): return "Flower"
