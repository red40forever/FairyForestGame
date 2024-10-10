class_name InteractableGridObject
extends GridObject

# Child classes should override.
func request_interaction(slot: Slot) -> bool:
	assert(false, "Subclasses must override request_interaction(Slot)")
	return false
