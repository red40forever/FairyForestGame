extends CharacterBody2D

@export_group("Movement")
@export var speed = 300.0
@export var accel = 7.0

var target: Vector2

func _ready():
	target = self.position

func _physics_process(delta: float) -> void:
	var direction := target - self.position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction*speed, accel*delta)
	
	move_and_slide()

# TODO function that sets target, 
# making sure to translate tilemap coords to position coords if needed
