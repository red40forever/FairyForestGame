extends Node2D

@export var camera: PanCamera
@export var resource: GridObjectAttributes

var inventory: Slot # Slot usage example

func _ready():
	# Slot usage example:
	var accepted_resources: Array[Slot.ResourceType] = [
		Slot.ResourceType.HONEY,
		Slot.ResourceType.POLLEN
	]
	inventory = Slot.new(accepted_resources, 20)
	
	# debug
	GameManager.tilemap_manager.create_object_at_coords(resource, Vector2i(5,5))

func _process(delta):
	if Input.is_action_just_pressed("debug_trigger"):
		GameManager.day_cycle_manager.day_changed.emit()
