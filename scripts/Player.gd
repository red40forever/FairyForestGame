extends Node2D

@export var camera: PanCamera

var honey: ResourceSlot


func _ready():
	honey = ResourceSlot.new(ResourceType.HONEY, 20) # For example
