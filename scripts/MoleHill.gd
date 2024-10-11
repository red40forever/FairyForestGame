class_name MoleHill
extends HomeTile

func get_class_name(): return "MoleHill"

func _ready() -> void:
	entity_grid_object_attributes = Resources.find("objects")["mole"]
	entity_attributes = Resources.find("entity_attributes")["mole"]
	resource_type = Slot.ResourceType.NULL
	product_type = Slot.ResourceType.MUSHROOM
	selected_withdraw_type = Slot.ResourceType.MUSHROOM
	super()
