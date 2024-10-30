class_name HomeTile
extends InteractableTile

@export_group("Type Assignments")
@export var entity_grid_object_attributes: GridObjectAttributes
@export var entity_attributes: EntityAttributes

@export_group("Constraints")
@export var max_entities: int = 2
@export var new_entity_cost: int = 2
@export var new_entity_resource_type: Slot.ResourceType
#@export var base_resource_is_final_form: bool = false

@export_group("Initial Values")
@export var current_entities: int = 0 # how many entities belong to this home
var current_entities_list: Array = [] # entities that are spawned in the world

func _ready() -> void:
	super()

func _on_day_start():
	super()
	
	# TODO REDO: New entities created if possible
	# var product_count = slot.get_resource_count(product_type)
	# if product_count >= new_entity_cost:
	# 	var possible_new_entities: int = floor(product_count / new_entity_cost)
	# 	var entities_to_create: int
	# 	# Make sure the entities we add don't exceed the maximum we can store
	# 	if possible_new_entities + current_entities > max_entities:
	# 		entities_to_create = max_entities - current_entities
	# 	else:
	# 		entities_to_create = possible_new_entities
	# 	current_entities = current_entities + entities_to_create
	# 	var to_remove = entities_to_create * new_entity_cost
	# 	if  to_remove > 0:
	# 		slot.remove_resource(product_type, to_remove)


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

func get_class_name(): return "HomeTile"


func add_entity(entity: Entity):
	var old_home = entity.home
	entity.home = self
	# update old home
	if old_home != null:
		old_home.remove_entity(entity)
	# update this home
	current_entities += 1
	current_entities_list.append(entity)
	# guh

func remove_entity(entity: Entity):
	current_entities -= 1
	entity.return_home.disconnect(_on_entity_returned_home)
	if current_entities_list.has(entity):
		var index = current_entities_list.find(entity)
		current_entities_list.remove_at(index)
