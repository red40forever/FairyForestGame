class_name HomeTile
extends GridObject

@export_group("Type Assignments")
@export var home_type: Constants.HomeTileTypes
@export var entity_grid_object_attributes: GridObjectAttributes
@export var entity_attributes: EntityAttributes

@export_group("Constraints")
@export var max_entities: int = 3
@export var max_storage: int = 5 # resources and products share the same cap
@export var new_entity_cost: int = 2
@export var base_resource_is_final_form: bool = false

@export_group("Initial Values")
@export var current_resources: int = 0
@export var current_products: int = 0
@export var current_entities: int = 0 # how many entities belong to this home

func _ready() -> void:
	# TODO connect signal to day change
	# and any other needed signals
	pass

func _on_day_changed():
	# New entities created if possible
	if current_products >= new_entity_cost:
		var possible_new_entities: int = floor(current_products / new_entity_cost)
		var entities_to_create: int
		# Make sure the entities we add don't exceed the maximum we can store
		if possible_new_entities + current_entities > max_entities:
			entities_to_create = max_entities - current_entities
		else:
			entities_to_create = possible_new_entities
		current_entities = current_entities + entities_to_create
		current_products = current_products - (entities_to_create * new_entity_cost)
	
	# New product created by consuming resources if possible
	current_products += current_resources
	current_products = 0
	
	# Spawn available bees into the world
	var map_pos = GameManager.tilemap_manager.ground_layer.local_to_map(self.position)
	var possible_placement_positions = [map_pos + Vector2i(0, 1), map_pos + 
		Vector2i(1, 0), map_pos + Vector2i(1, 1), map_pos + Vector2i(0, -1), 
		map_pos + Vector2i(-1, 0), map_pos + Vector2i(-1, 1), map_pos + 
		Vector2i(1, -1), map_pos + Vector2i(-1, -1)]
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

func _on_entity_returned_home(incoming_resources: int, incoming_entity: Node):
	# Add resources to home if possible
	var resources_to_add
	if (incoming_resources + current_resources + current_products) > max_storage:
		resources_to_add = max_storage - (current_resources + current_products)
	else:
		resources_to_add = incoming_resources
	
	if(base_resource_is_final_form):
		current_products = current_products + resources_to_add
	else:
		current_resources = current_resources + resources_to_add
	
	# Remove entity from the scene tree
	incoming_entity.queue_free()
