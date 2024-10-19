extends TextureButton

@export var hovered_size: float = 1.1

@onready var original_scale: Vector2 = scale


func _ready():
	GameManager.game_paused.connect(func(): visible = false)
	GameManager.game_unpaused.connect(func(): visible = true)


func _on_pressed() -> void:
	GameManager.day_manager.next_day()


func _on_mouse_entered():
	scale = original_scale * hovered_size


func _on_mouse_exited():
	scale = original_scale
