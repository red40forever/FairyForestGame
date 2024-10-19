extends Sprite2D

@export var animation_speed: float = 1.0


func move_to_grid_position(grid_position: Vector2i):
	var accessible = GameManager.tilemap_manager.placement_helper.is_tile_accessible(grid_position)
	visible = accessible
	print("tile at ", grid_position, " is accessible: ", accessible)
	
	var placement_indicator_pos = %GroundLayer.to_global(%GroundLayer.map_to_local(grid_position))
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", placement_indicator_pos, animation_speed)
