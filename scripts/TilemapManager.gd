class_name TilemapManager
extends Node

@export var ground_layer: TileMapLayer
@export var grid_object_container: Node2D
@export var placement_helper: Node2D


func create_object_at_coords(object_attributes: GridObjectAttributes, coords: Vector2i):
	var grid_object = object_attributes.node.instantiate()
	grid_object.attributes = object_attributes
	grid_object.grid_coordinates = coords
	grid_object_container.add_child(grid_object)
	return grid_object
