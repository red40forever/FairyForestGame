class_name TreeManager
extends Node2D

@export var resource_requirements_by_stage: Array = [
	{ "honey": 3, "pollen": 6, "mushrooms": 0 },
	{ "honey": 3, "pollen": 12, "mushrooms": 8 }
]
static var stage = 0 
@export var ending_stage = 2 # when the stage becomes this, the player wins
var slot_honey = Slot
var slot_pollen = Slot
var slot_mushrooms = Slot

signal stage_completed(stage: int) # emitted when any stage is completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_new_slots()

func create_new_slots():
	slot_honey = Slot.new([Slot.ResourceType.HONEY], resource_requirements_by_stage[stage]["honey"])
	slot_pollen = Slot.new([Slot.ResourceType.POLLEN], resource_requirements_by_stage[stage]["pollen"])
	slot_honey = Slot.new([Slot.ResourceType.MUSHROOM], resource_requirements_by_stage[stage]["mushrooms"])

func progress_stage():
	stage += 1
	stage_completed.emit(stage)
	if stage == 1:
		%TreeSprite.texture = preload("res://textures/tree_weak.png")
		Dialogic.start("MoleFairy1")
	elif stage == 2:
		%TreeSprite.texture = preload("res://textures/tree_alive.png")
		Dialogic.start("Ending")
	
	if stage >= ending_stage:
		on_ending_stage_reached()
		return
	
	create_new_slots()

func on_ending_stage_reached():
	pass #TODO
