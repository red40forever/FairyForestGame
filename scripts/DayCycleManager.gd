class_name DayCycleManager
extends Node2D

var day_count: int = 0
var day_changing: bool = false

signal day_changed(day_count: int)
signal day_ending

func end_day():
	day_ending.emit()

func next_day():
	day_changing = true
	day_count += 1
	
	# Call all lingering entities home
	for ent in GameManager.tilemap_manager.grid_objects:
		if ent is Entity:
			ent.return_home.emit(ent, ent.slot)
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	
	var tween_func = func(value: float):
		%ScreenPostProcessing.material.set_shader_parameter(
			"night_tint_amount", value
		)
	tween.tween_method(tween_func, 0.0, 1.0, 1.5)
	tween.tween_interval(0.5)
	tween.tween_method(tween_func, 1.0, 0.0, 1.5)
	await tween.finished
	
	day_changing = false
	day_changed.emit(day_count)


func _process(_delta):
	if OS.has_feature("editor"):
		if Input.is_action_just_pressed("debug_trigger"):
			next_day()
