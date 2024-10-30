class_name DayCycleManager
extends Node2D

@export var energy_maximums_per_stage: Array = [3, 4]

var day_count: int = 0
var day_changing: bool = false


var curr_energy = 3

signal day_ending
signal day_starting


func next_day():
	day_ending.emit()
	
	day_changing = true
	day_count += 1
	
	# Call all lingering entities home
	for entity: Entity in GameManager.tilemap_manager.get_all_awake_entities():
		entity.set_activity_state(Entity.activityStates.ASLEEP)
	
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
	
	curr_energy = energy_maximums_per_stage[TreeManager.stage]
	
	day_changing = false
	day_starting.emit()


func decrement_energy():
	curr_energy -= 1
	UIManager.set_energy_display_amount(curr_energy)


func _process(_delta):
	if OS.has_feature("editor"):
		if Input.is_action_just_pressed("debug_trigger"):
			next_day()
