extends CharacterBody2D

@export_group("Movement")
@export var speed = 300.0
@export var accel = 7.0

# TODO For the NavAgent to work, need to draw a NavigationRegion2D over the playable area.
@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _physics_process(delta: float) -> void:
	var direction := Vector2()
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction*speed, accel*delta)
	
	move_and_slide()

# TODO function that sets nav.target_position based on tilemap
