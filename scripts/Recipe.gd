@tool
class_name Recipe
extends Resource

@export var id: String
@export var resource: Slot.ResourceType
@export var cost: int
@export var building: GridObjectAttributes


func has_title() -> bool:
	return true

func get_full_name() -> String:
	return "%s (%s x%d)" % [id, resource, cost]
