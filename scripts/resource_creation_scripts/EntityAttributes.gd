class_name EntityAttributes
extends Resource

@export_group("Basics")
@export var id: String
@export var name: String

@export_group("Movement")
@export var speed: float
@export var accel: float

@export_group("Interactions")
@export var max_interactions: int
