extends Sprite2D

@export var walking: bool = true
@export var frame_duration: float = 0.25


# Called when the node enters the scene tree for the first time.
func _ready():
	%Timer.timeout.connect(_on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_timer_timeout():
	if walking:
		frame += 1
