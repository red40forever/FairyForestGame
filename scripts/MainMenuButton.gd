class_name MainMenuButton
extends Button

@export var highlight_tint: Color = Color(1, 1, 0.51)


func _ready() -> void:
	mouse_entered.connect(on_hover_start)
	mouse_exited.connect(on_hover_finish)


func _on_pressed() -> void:
	pass


func on_hover_start():
	modulate = highlight_tint


func on_hover_finish():
	modulate = Color.WHITE
