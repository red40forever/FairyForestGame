class_name Mushroom
extends ResourceTile

func get_class_name(): return "Mushroom"

func _ready() -> void:
	produced_resources = [Slot.ResourceType.MUSHROOM, Slot.ResourceType.SPORE]
	super()

# TODO already called on day change
func upgrade_tier():
	pass
