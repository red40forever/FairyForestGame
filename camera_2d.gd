extends Camera2D

var speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 200


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := Vector2.ZERO
	
	# WASD controls
	if Input.is_action_pressed("map_up"):
		direction.y -= 1
	if Input.is_action_pressed("map_down"):
		direction.y += 1
	if Input.is_action_pressed("map_left"):
		direction.x -= 1
	if Input.is_action_pressed("map_right"):
		direction.x += 1
	
	# Normalize the direction vector to maintain consistent speed
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	# Move the camera
	position += direction * speed * delta
