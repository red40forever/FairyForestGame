extends Node2D

@export_group("Constraints")
@export var max_bees: int = 3
@export var max_storage: int = 5
@export var new_bee_cost: int = 2

# Pollen and honey share the same resource cap in beehives
var current_pollen: int = 0
var current_honey: int = 0
var current_bees_total: int = 0 # how many bees belong to this hive
var current_bees_at_home: int = 0 # how many bees are at home, aka not assigned to a task

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TODO input events for managing beehives
func _input(event: InputEvent) -> void:
	pass

# TODO signal receiver from day change when day change signal is implemented
func on_day_change():
	# New bees created if possible
	if current_honey >= new_bee_cost:
		var bees_sum: int = current_bees_total + floor(current_honey / new_bee_cost)
	
	# New honey created by consuming pollen if possible
	current_honey += current_pollen
	current_pollen = 0
