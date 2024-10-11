extends Sprite2D

@export var animation_speed: float = 1.0


func move_to_grid_position(grid_position: Vector2i):
	var placement_indicator_pos = %GroundLayer.map_to_local(grid_position)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", placement_indicator_pos, animation_speed)
