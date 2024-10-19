class_name DayCycleManager
extends Node2D

var day_count: int = 0

signal day_changed(day_count: int)
signal day_ending()

func end_day():
	day_ending.emit()

func next_day():
	day_count += 1
	
	# Call all lingering entities home
	for ent in GameManager.tilemap_manager.grid_objects:
		if ent is Entity:
			ent.return_home.emit(ent, ent.slot)
	day_changed.emit(day_count)
	

func _process(_delta):
	if OS.has_feature("editor"):
		if Input.is_action_just_pressed("debug_trigger"):
			next_day()
