class_name Entity
extends CharacterBody2D

@export_group("Resources")
@export var entity_attributes: EntityAttributes

var target: Vector2
var home: Node2D
var interactions_completed: int = 0
var idle: bool = true

signal entity_arrived_at_home(resources_to_deposit: int, entity_reference_to_free: Node)

func _ready():
	# TODO set home? or maybe the home tile itself sets this when it spawns the bee? idk
	target = self.position

func _process(delta: float) -> void:
	if not idle:
		if interactions_completed >= entity_attributes.max_interactions:
			return_home()
	

func _physics_process(delta: float) -> void:
	if not idle:
		var direction := target - self.position
		direction = direction.normalized()
		# TODO sprite faces direction of movement
		
		velocity = velocity.lerp(direction*entity_attributes.speed, entity_attributes.accel*delta)
		
		move_and_slide()

# TODO how to receive a new target? signal? from where?
func set_new_target(new_target: Vector2):
	idle = false
	# TODO if new_target is tilemap coords, translate to map coords
	target = new_target

func return_home():
	target = home.global_position

# TODO determine what type of target we're at, do stuff accordingly
func on_reached_target():
	pass
