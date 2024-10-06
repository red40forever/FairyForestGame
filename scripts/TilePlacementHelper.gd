extends Node2D

@export var tilemap_manager: TilemapManager
@export var placement_indicator: Sprite2D
@export var selected_object: GridObjectAttributes

var last_grid_pos: Vector2i = Vector2i.ZERO


func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var tilemap_pos = %GroundLayer.local_to_map(mouse_pos)
	if tilemap_pos != last_grid_pos:
		placement_indicator.move_to_grid_position(tilemap_pos)
	last_grid_pos = tilemap_pos


func place_at_coords(coordinates: Vector2i):
	tilemap_manager.create_object_at_coords(selected_object, coordinates)


func quantize_local_position(local_pos: Vector2):
	var tilemap_pos = %GroundLayer.local_to_map(local_pos)
	return %GroundLayer.map_to_local(tilemap_pos)
