class_name DayCycleManager
extends Node2D

var day_count: int = 0

signal day_changed(day_count: int)

func change_day():
	day_count += 1
	day_changed.emit(day_count)

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
