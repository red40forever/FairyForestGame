class_name InteractableGridObject
extends GridObject

# InteractableGridObjects are GridObjects that can change/exchange resources
# from Slots during an interaction.

# Child classes should override this method.
func request_interaction(slot: Slot) -> bool:
	assert(false, "Subclasses must override request_interaction(Slot)")
	return false
