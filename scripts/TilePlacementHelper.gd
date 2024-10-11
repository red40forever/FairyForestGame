class_name TilePlacementHelper
extends Node2D

@export_category("Building")
@export var building_recipes: Array[Recipe]

@export_category("References")
@export var tilemap_manager: TilemapManager
@export var placement_indicator: Sprite2D

@export var test_object: GridObjectAttributes

var last_grid_pos: Vector2i = Vector2i.ZERO


func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	var tilemap_pos = %GroundLayer.local_to_map(mouse_pos)
	if tilemap_pos != last_grid_pos:
		placement_indicator.move_to_grid_position(tilemap_pos)
	last_grid_pos = tilemap_pos


func place_at_coords(grid_object_attributes: GridObjectAttributes, coordinates: Vector2i) -> GridObject:
	return tilemap_manager.create_object_at_coords(grid_object_attributes, coordinates)


func quantize_local_position(local_pos: Vector2):
	var tilemap_pos = %GroundLayer.local_to_map(local_pos)
	return %GroundLayer.map_to_local(tilemap_pos)


func get_recipe_for_grid_object_attributes(grid_object_attributes: GridObjectAttributes):
	for recipe in building_recipes:
		if recipe.building.id == grid_object_attributes.id:
			return recipe
	return null


func get_recipe_by_id(recipe_id: String):
	for recipe in building_recipes:
		if recipe.id == recipe_id:
			return recipe
	return null


func is_tile_accessible(coords: Vector2i):
	return !%FogOfWarLayer.is_fog_at_tile(coords)
