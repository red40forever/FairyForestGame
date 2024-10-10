class_name HomeTile
extends InteractableGridObject

@export_group("Type Assignments")
@export var entity_grid_object_attributes: GridObjectAttributes
@export var entity_attributes: EntityAttributes
@export var resource_type: Slot.ResourceType
@export var product_type: Slot.ResourceType

@export_group("Constraints")
@export var max_entities: int = 3
@export var max_storage: int = 5 # resources and products share the same cap
@export var new_entity_cost: int = 2
#@export var base_resource_is_final_form: bool = false

@export_group("Initial Values")
@export var initial_resources: int = 0
@export var initial_products: int = 0
@export var current_entities: int = 0 # how many entities belong to this home

var slot: Slot
var selected_withdraw_type: Slot.ResourceType
@onready var display = %SlotDisplay

func _ready() -> void:
	GameManager.day_manager.day_changed.connect(_on_day_changed)
	initialize_slot()
	selected_withdraw_type = product_type
	display.resource_clicked.connect(_on_resource_clicked)

func initialize_slot():
	var accepted = [resource_type, product_type]
	slot = Slot.new(accepted, max_storage)
	slot.add_resource_overflow_safe(resource_type, initial_resources)
	slot.add_resource_overflow_safe(product_type, initial_products)

func _on_day_changed(_count):
	# New entities created if possible
	var product_count = slot.get_resource_count(product_type)
	if product_count >= new_entity_cost:
		var possible_new_entities: int = floor(product_count / new_entity_cost)
		var entities_to_create: int
		# Make sure the entities we add don't exceed the maximum we can store
		if possible_new_entities + current_entities > max_entities:
			entities_to_create = max_entities - current_entities
		else:
			entities_to_create = possible_new_entities
		current_entities = current_entities + entities_to_create
		slot.remove_resource(product_type, (entities_to_create * new_entity_cost))
	
	# New product created by consuming resources if possible
	slot.add_resource_overflow_safe(product_type, slot.get_resource_count(resource_type))
	slot.set_resource_count(resource_type, 0)
	
	# Spawn available bees into the world
	var map_pos = GameManager.tilemap_manager.ground_layer.local_to_map(self.position)
	# weird ass isometric positioning...
	var possible_placement_positions = [map_pos + Vector2i(0, -2), map_pos + 
		Vector2i(0, -1), map_pos + Vector2i(1, 0), map_pos + Vector2i(0, 1), 
		map_pos + Vector2i(0, 2), map_pos + Vector2i(-1, 1), map_pos + 
		Vector2i(-1, 0), map_pos + Vector2i(-1, -1)]
	var placed_entities = 0
	for coords in possible_placement_positions:
		if len(GameManager.tilemap_manager.get_objects_at(coords)) <= 0:
			# Position is empty; place a bee here
			var entity = GameManager.tilemap_manager.create_object_at_coords(entity_grid_object_attributes, coords)
			entity.set_home(self)
			entity.set_attributes(entity_attributes)
			entity.return_home.connect(_on_entity_returned_home)
			placed_entities += 1
		if placed_entities >= current_entities:
			break

func _on_resources_received(incoming_resources: Slot):
	# Add resources to home if possible
	var types = incoming_resources.accepted_types
	for type in types:
		if slot.accepted_types.has(type):
			# Home's slot accepts resources
			var old = slot.get_resource_count(type)
			slot.add_resource_overflow_safe(type, incoming_resources.get_resource_count(type))
			# Resources removed from incoming slot, just in case
			var change = slot.get_resource_count(type) - old
			incoming_resources.remove_resource(type, change)
	

func _on_entity_returned_home(incoming_entity: Entity, incoming_resources: Slot):
	_on_resources_received(incoming_resources)
	# Remove entity from the scene tree
	incoming_entity.queue_free()

func _on_resource_clicked(resource: Slot.ResourceType):
	selected_withdraw_type = resource

# HomeTile's request_interaction is defined such that
# the interactor receives resources of the HomeTile's selected_withdraw_type
func request_interaction(inc_slot: Slot) -> bool:
	for type in inc_slot.accepted_types:
		if type == selected_withdraw_type:
			# Attempt to give resource to interactor
			var overflow = inc_slot.add_resource_overflow_safe(type, slot.get_resource_count(type))
			var exchange = slot.get_resource_count(type) - overflow
			slot.remove_resource(type, exchange)
			if exchange > 0:
				return true
	return false
