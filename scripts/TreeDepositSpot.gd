class_name TreeDepositSpot
extends InteractableGridObject


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_class_name() -> String: return "TreeDepositSpot"

func request_interaction(slot: Slot) -> bool:
	return false # TODO
