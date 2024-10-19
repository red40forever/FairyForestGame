class_name QuitConfirmDialog
extends TextureRect

var original_scale: Vector2

signal animation_finished(open: bool)


func _ready():
	original_scale = scale
	scale = Vector2(0, original_scale.y)
	visible = false
	
	# Always process, even when paused
	process_mode = Node.PROCESS_MODE_ALWAYS


func animate_open():
	visible = true
	
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", original_scale, 0.3)
	tween.tween_callback(func(): animation_finished.emit(true))


func animate_close():
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2(0, original_scale.y), 0.2)
	tween.tween_callback(
		func():
			visible = false
			animation_finished.emit(false)
	)
