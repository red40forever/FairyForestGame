class_name ResourceTile
extends GridObject

@export_group("Production")
@export var produced_resources: Array[Slot.ResourceType]
@export var daily_production: int = 1
@export var max_storage: int = 5
var slot: Slot

func _ready() -> void:
	GameManager.day_manager.day_changed.connect(_on_day_changed)
	slot = Slot.new(produced_resources, max_storage)

func _on_day_changed():
	pass

func request_interaction(incoming_slot: Slot) -> bool:
	var retval = false
	# If the interactor can receive something that I produce,
	for type in incoming_slot.accepted_types:
		if slot.accepted_types.has(type):
			pass #TODO
			# Attempt to give resource
	return false # TODO
