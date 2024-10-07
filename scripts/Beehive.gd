class_name Beehive
extends GridObject

@export_group("Basics")
@export var home_type: Constants.HomeTileTypes
@export var entity_grid_object_attributes: GridObjectAttributes

@export_group("Constraints")
@export var max_bees: int = 3
@export var max_storage: int = 5
@export var new_bee_cost: int = 2

# Pollen and honey share the same resource cap in beehives
var current_pollen: int = 0
var current_honey: int = 0
var current_bees: int = 0 # how many bees belong to this hive

# TODO input events for managing beehives (?)
func _input(event: InputEvent) -> void:
	pass

# TODO signal receiver from day change when day change signal is implemented
func _on_day_changed():
	# New bees created if possible
	if current_honey >= new_bee_cost:
		var possible_new_bees: int = floor(current_honey / new_bee_cost)
		var bees_to_create: int
		# Make sure the bees we add don't exceed the maximum we can store
		if possible_new_bees + current_bees > max_bees:
			bees_to_create = max_bees - current_bees
		else:
			bees_to_create = possible_new_bees
		current_bees = current_bees + bees_to_create
		current_honey = current_honey - (bees_to_create * new_bee_cost)
	
	# New honey created by consuming pollen if possible
	current_honey += current_pollen
	current_pollen = 0
	
	# Spawn available bees into the world
	# make sure to connect to their entity_arrived_at_home signals
	var map_pos = GameManager.tilemap_manager.ground_layer.local_to_map(self.position)
	var possible_placement_positions = [map_pos + Vector2i(0, 1), map_pos + 
		Vector2i(1, 0), map_pos + Vector2i(1, 1), map_pos + Vector2i(0, -1), 
		map_pos + Vector2i(-1, 0), map_pos + Vector2i(-1, 1), map_pos + 
		Vector2i(1, -1), map_pos + Vector2i(-1, -1)]
	var placed_bees = 0
	for coords in possible_placement_positions:
		if len(GameManager.tilemap_manager.get_objects_at(coords)) <= 0:
			# Position is empty; place a bee here
			var bee = GameManager.tilemap_manager.create_object_at_coords(entity_grid_object_attributes, coords)
			bee.return_home.connect(_on_entity_returned_home)
			placed_bees += 1
		if placed_bees >= current_bees:
			break

func _on_entity_returned_home(incoming_pollen: int, incoming_bee: Node):
	# Add pollen to hive if possible
	var pollen_to_add
	if (incoming_pollen + current_pollen + current_honey) > max_storage:
		pollen_to_add = max_storage - (current_pollen + current_honey)
	else:
		pollen_to_add = incoming_pollen
	current_pollen = current_pollen + pollen_to_add
	
	# Remove bee from the scene tree
	incoming_bee.queue_free()
