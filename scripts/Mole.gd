class_name Mole
extends Entity


func set_new_target(new_target: Vector2i):
	super(new_target)
	main_sprite.play("walk")


func _on_tween_finished():
	super()
	main_sprite.play("idle")


func try_interact_with_object(object: GridObject):
	# TODO
	pass
