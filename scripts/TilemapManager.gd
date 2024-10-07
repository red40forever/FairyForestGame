class_name TilemapManager
extends Node

@export var ground_layer: TileMapLayer
@export var grid_object_container: Node2D
@export var placement_helper: Node2D

var grid_objects: Array[GridObject] = []


func create_object_at_coords(object_attributes: GridObjectAttributes, coords: Vector2i):
	var grid_object = object_attributes.node.instantiate()
	#grid_object.attributes = object_attributes
	grid_object.grid_coordinates = coords
	grid_object_container.add_child(grid_object)
	grid_objects.append(grid_object)
	grid_object.tree_exiting.connect(_on_grid_object_deleted.bind(grid_object))
	return grid_object


func get_objects_at(coordinates: Vector2i):
	var objects_at_coords = []
	for grid_object: GridObject in grid_objects:
		if grid_object.grid_coordinates == coordinates:
			objects_at_coords.append(grid_object)
	return objects_at_coords


func _on_grid_object_deleted(grid_object: GridObject):
	grid_objects.erase(grid_object)
