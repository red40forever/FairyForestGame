extends TextureButton

@export var hovered_size: float = 1.1

@onready var original_scale: Vector2 = scale


func _ready():
	# Hide the button while dialogue is happening
	UIManager.dialogue_started.connect(_hide_button)
	UIManager.dialogue_ended.connect(_show_button)
	
	# Hide the button while the day is changing
	GameManager.day_manager.day_ending.connect(_hide_button)
	GameManager.day_manager.day_starting.connect(_show_button)


func _on_pressed() -> void:
	GameManager.day_manager.next_day()


func _on_mouse_entered():
	scale = original_scale * hovered_size


func _on_mouse_exited():
	scale = original_scale


func _show_button():
	visible = true
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", original_scale, 0.2)


func _hide_button():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	tween.tween_callback(func(): visible = false)
