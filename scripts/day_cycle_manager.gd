class_name DayCycleManager
extends Node2D

var day_count: int = 0

signal day_changed(day_count: int)

func change_day():
	day_count += 1
	day_changed.emit(day_count)

func _process(delta):
	if Input.is_action_just_pressed("debug_trigger"):
		change_day()
