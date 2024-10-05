extends Node2D

@export_group("Constraints")
@export var max_bees: int = 3
@export var max_storage: int = 5

# Pollen and honey share the same resource cap in beehives
var current_pollen: int = 0
var current_honey: int = 0
var current_bees: int = 0

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
