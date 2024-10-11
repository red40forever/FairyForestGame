class_name ResourceTile
extends InteractableGridObject

@export_group("Production")
@export var produced_resources: Array[Slot.ResourceType]
@export var daily_production: int = 1
@export var max_storage: int = 5
var slot: Slot

@export_group("Tiers")
@export var sprite_tiers: Array = [Texture2D, Texture2D, Texture2D]
@export var tier = 0
@export var max_tier = 2

func _ready() -> void:
	GameManager.day_manager.day_changed.connect(_on_day_changed)
	slot = Slot.new(produced_resources, max_storage)

func _on_day_changed():
	for type in produced_resources:
		slot.add_resource_overflow_safe(type, daily_production)

# This is never called in this base class, because the conditions for
# upgrading tiers varies per resource tile.
func upgrade_tier():
	tier = min(tier+1, max_tier)
	var tex = sprite_tiers[tier]
	$Sprite2D.texture = tex
	daily_production += 1


# Entities should call this function and pass in their Slot
# to harvest resources from this tile.
# Returns true if the interaction was successful and something happened, false otherwise
func request_interaction(incoming_slot: Slot) -> bool:
	# If the interactor can receive something that I produce,
	for type in incoming_slot.accepted_types:
		if slot.accepted_types.has(type):
			# Attempt to give it
			var overflow = incoming_slot.add_resource_overflow_safe(type, slot.get_resource_count(type))
			var exchange = slot.get_resource_count(type) - overflow
			if exchange > 0:
				slot.remove_resource(type, exchange)
				return true
	return false # If no exchange ever occurred

# Subclasses can override to provide more logic, 
# such as when to upgrade tiers
func supplemental_interaction_logic(incoming_slot: Slot) -> bool:
	return false

func get_class_name(): return "ResourceTile"
