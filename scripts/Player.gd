extends Node2D

@export var camera: PanCamera
@export var resource: GridObjectAttributes

var honey: ResourceSlot


func _ready():
	honey = ResourceSlot.new(ResourceType.HONEY, 20) # For example
	# debug
	GameManager.tilemap_manager.create_object_at_coords(resource, Vector2i(5,5))
