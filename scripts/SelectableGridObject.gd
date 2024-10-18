class_name SelectableGridObject
extends GridObject


func on_click():
	# Select this object when clicked, or deselect if it's already selected
	if !selected:
		GameManager.player.selected_object = self
	else:
		GameManager.player.selected_object = null
