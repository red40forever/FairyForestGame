class_name TreeDepositSpot
extends InteractableGridObject

var slots
var types = {"honey": Slot.ResourceType.HONEY, "pollen": Slot.ResourceType.POLLEN, 
		"mushrooms": Slot.ResourceType.MUSHROOM}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var p = get_parent()
	slots = {types["honey"]: p.slot_honey, "honey": p.slot_honey,
	types["pollen"]: p.slot_pollen, "pollen": p.slot_pollen, 
	types["mushrooms"]: p.slot_mushrooms, "mushrooms": p.slot_mushrooms}

func get_class_name() -> String: return "TreeDepositSpot"

# Interactor can deposit resources.
func request_interaction(incoming_slot: Slot) -> bool:
	for type in incoming_slot.accepted_types:
		var resource_count = incoming_slot.get_resource_count(type)
		if resource_count == 0:
			continue
		if types.has(type):
			var slot = slots[type]
			var overflow = slot.add_resource_overflow_safe(type, resource_count)
			var exchange = slot.get_resource_count(type) - overflow
			slot.remove_resource(type, exchange)
			if exchange > 0:
				return true
	return false 
