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
	return false # TODO
