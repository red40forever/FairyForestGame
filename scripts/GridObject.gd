class_name GridObject
extends Sprite2D

@export var attributes: GridObjectAttributes

var grid_coordinates: Vector2i


# Called when the node enters the scene tree for the first time.
func _ready():
	name = attributes.name
	texture = attributes.texture
	global_position = GameManager.tilemap_manager.ground_layer.map_to_local(grid_coordinates)
	print(position, grid_coordinates)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
