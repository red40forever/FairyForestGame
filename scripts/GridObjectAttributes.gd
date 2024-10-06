class_name GridObjectAttributes
extends Resource

@export var id: String
@export var name: String
@export var texture: Texture2D

func has_title() -> bool:
	return (name != "")

func get_full_name() -> String:
	if (name == ""):
		return "GridObject"
	return name