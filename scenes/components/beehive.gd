extends Node2D

@export_group("Constraints")
@export var max_bees: int = 3
@export var max_storage: int = 5
@export var new_bee_cost: int = 2

# Pollen and honey share the same resource cap in beehives
var current_pollen: int = 0
var current_honey: int = 0
var current_bees: int = 0 # how many bees belong to this hive

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TODO input events for managing beehives (?)
func _input(event: InputEvent) -> void:
	pass

# TODO signal receiver from day change when day change signal is implemented
func on_day_change():
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
	
	# TODO spawn available bees into the world

# TODO signal receiver from bee when bee reaches home
func on_bee_return(incoming_pollen):
	# Add pollen to hive if possible
	var pollen_to_add
	if (incoming_pollen + current_pollen + current_honey) > max_storage:
		pollen_to_add = max_storage - (current_pollen + current_honey)
	else:
		pollen_to_add = incoming_pollen
	current_pollen = current_pollen + pollen_to_add
