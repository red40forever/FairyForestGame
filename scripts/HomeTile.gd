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
var current_entities_list: Array = [] # entities that are spawned in the world

@export_group("References")
@export var slot_display: SlotDisplay

var slot: Slot
var selected_withdraw_type: Slot.ResourceType

func _ready() -> void:
	super()
	
	initialize_slot()
	selected_withdraw_type = product_type
	
	slot_display.resource_clicked.connect(_on_resource_clicked)
	if slot_display:
		slot_display.displayed_slot = slot
	else:
		push_warning("HomeTile '", name, "' does not have a SlotDisplay.")

func initialize_slot():
	var accepted: Array[Slot.ResourceType] = [resource_type, product_type]
	slot = Slot.new(accepted, max_storage)
	
	if initial_resources > 0:
		slot.add_resource_overflow_safe(resource_type, initial_resources)
	if initial_products > 0:
		slot.add_resource_overflow_safe(product_type, initial_products)

func _on_day_changed():
	super()
	
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
		var to_remove = entities_to_create * new_entity_cost
		if  to_remove > 0:
			slot.remove_resource(product_type, to_remove)
	
	# New product created by consuming resources if possible
	slot.add_resource_overflow_safe(product_type, slot.get_resource_count(resource_type))
	slot.set_resource_count(resource_type, 0)
	
	# Spawn available entities into the world
	# TODO: Avoid despawning/spawning entities every day. That causes continuity issues.
	# BUG:  As a result, at the end of the day, undeposited resources in Entity slots will get destroyed.
	var possible_placement_positions = get_surrounding_free_and_accessible_tiles()
	var ran_out_of_tiles = false
	var entities_to_place = current_entities
	while entities_to_place > 0:
		for coords in possible_placement_positions:
			if entities_to_place == 0:
				break
			
			# Position is empty; place an entity here
			_place_entity_at_coords(coords)
			entities_to_place -= 1
		
		if ran_out_of_tiles:
			push_error(
				"HomeTile ", name, " at position ", grid_coordinates, " does not have enough space to spawn all entities. ",
				entities_to_place, " entities were not spawned."
			)
			break
		
		# Ran out of tiles, expand search to include occupied
		ran_out_of_tiles = true
		possible_placement_positions = get_surrounding_free_and_accessible_tiles(true)


func _place_entity_at_coords(coords: Vector2i):
	var entity = GameManager.tilemap_manager.create_object_at_coords(entity_grid_object_attributes, coords)
	entity.set_home(self)
	current_entities -= 1 # epic hacky solution
	entity.set_attributes(entity_attributes)
	#entity.return_home.connect(_on_entity_returned_home)
	current_entities_list.append(entity)


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
			if change > 0:
				incoming_resources.remove_resource(type, change)


func _on_entity_returned_home(incoming_entity: Entity, incoming_resources: Slot):
	_on_resources_received(incoming_resources)
	current_entities_list.remove_at(current_entities_list.find(incoming_entity))
	# Remove entity from the scene tree
	incoming_entity.despawn()

func _on_resource_clicked(resource: Slot.ResourceType):
	selected_withdraw_type = resource

# HomeTile's request_interaction is defined such that
# the interactor receives resources of the HomeTile's selected_withdraw_type
func request_interaction(inc_slot: Slot) -> bool:
	for type in inc_slot.accepted_types:
		if type == selected_withdraw_type:
			var old_val = inc_slot.get_resource_count(type)
			
			# Attempt to give resource to interactor:
			# TODO: Do something with the overflow
			var _overflow = inc_slot.add_resource_overflow_safe(type, slot.get_resource_count(type))
			
			# How much did we change by?
			var exchange = inc_slot.get_resource_count(type) - old_val
			if exchange > 0:
				slot.remove_resource(type, exchange)
				return true
	return false

func get_class_name(): return "HomeTile"


# TODO: Consolidate hover logic into shared base class
func on_hover_start():
	super()
	if slot_display:
		slot_display.set_open(true)


func on_hover_finish():
	super()
	if slot_display:
		slot_display.set_open(false)


func add_entity(entity: Entity):
	var old_home = entity.home
	entity.home = self
	# update old home
	if old_home != null:
		old_home.current_entities -= 1
		entity.return_home.disconnect(old_home._on_entity_returned_home)
		var list = old_home.current_entities_list
		if list.has(entity):
			var index = list.find(entity)
			old_home.current_entities_list.remove_at(index)
	# update this home
	current_entities += 1
	entity.return_home.connect(_on_entity_returned_home)
	current_entities_list.append(entity)
	# guh
