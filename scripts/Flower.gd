class_name Flower
extends ResourceTile

# TODO accepting pollen for upgrades
func supplemental_interaction_logic(incoming_slot: Slot) -> bool:
	return false

# TODO already called on day change
func upgrade_tier():
	pass

func get_class_name(): return "Flower"
