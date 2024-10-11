class_name Beehive
extends HomeTile

func _ready():
	super()
	if randf() > 0.5:
		main_sprite.flip_h = true

func get_class_name(): return "Beehive"
