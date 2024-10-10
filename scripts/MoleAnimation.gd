extends Sprite2D

@export var walking: bool = false:
	set(value):
		%AnimationPlayer.current_animation = 
