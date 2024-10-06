class_name GridObject
extends Sprite2D

@export var attributes: GridObjectAttributes

var grid_coordinates: Vector2i


func _ready():
	name = attributes.name
	texture = attributes.texture
	global_position = GameManager.tilemap_manager.ground_layer.map_to_local(grid_coordinates)
