class_name MoleHill
extends HomeTile

func get_class_name(): return "MoleHill"

func _ready() -> void:
	super()
	entity_grid_object_attributes = Resources.find("object")["mole"]
	entity_grid_object_attributes = Resources.find("entity_attributes")["mole"]
