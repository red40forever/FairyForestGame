class_name TreeManager
extends Node2D

@export var resource_requirements_by_stage: Array = [
	{ "honey": 3, "pollen": 6, "mushrooms": 0 },
	{ "honey": 3, "pollen": 12, "mushrooms": 8 }
]
@export var stage = 0 
@export var ending_stage = 2 # when the stage becomes this, the player wins
var slot_honey = Slot
var slot_pollen = Slot
var slot_mushrooms = Slot

signal stage_completed # emitted when any stage is completed
signal stage_zero_completed
signal stage_one_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_new_slots()

func create_new_slots():
	slot_honey = Slot.new([Slot.ResourceType.HONEY], resource_requirements_by_stage[stage]["honey"])
	slot_pollen = Slot.new([Slot.ResourceType.POLLEN], resource_requirements_by_stage[stage]["pollen"])
	slot_honey = Slot.new([Slot.ResourceType.MUSHROOM], resource_requirements_by_stage[stage]["mushrooms"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
