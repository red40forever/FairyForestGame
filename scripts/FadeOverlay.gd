class_name FadeOverlay
extends ColorRect

@export var fade_duration: float = 1.0
@export var wait_time_after_fade: float = 1.0
@export var fade_in_on_start: bool = false

var fade_color: Color = color

signal fade_out_complete
signal fade_in_complete


func _ready():
	visible = true
	
	fade_color = color
	if fade_in_on_start:
		color = fade_color
		fade_in()
	else:
		color = Color(fade_color, 0)


func fade_in():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color(fade_color, 0), fade_duration)
	tween.tween_callback(func(): fade_in_complete.emit())


func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", fade_color, fade_duration)
	tween.tween_interval(wait_time_after_fade)
	tween.tween_callback(func(): fade_out_complete.emit())
