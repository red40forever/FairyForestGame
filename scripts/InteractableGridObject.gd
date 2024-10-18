class_name InteractableGridObject
extends GridObject

# InteractableGridObjects are GridObjects that can change/exchange resources
# from Slots during an interaction.

# Child classes should override this method.
func request_interaction(_slot: Slot) -> bool:
	assert(false, "Subclasses must override request_interaction(Slot)")
	return false


func on_click():
	super()
	GameManager.player.set_target_of_selected_entity(self)
