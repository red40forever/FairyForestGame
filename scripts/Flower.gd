class_name Flower
extends ResourceTile

# TODO accepting pollen for upgrades
func supplemental_interaction_logic(incoming_slot: Slot) -> bool:
	return false

# TODO on day change
func _try_upgrade_tier():
	pass
