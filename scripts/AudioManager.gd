extends FmodEventEmitter2D

var event: FmodEvent
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(i < 5000):
		i = i + 1
	else:
		stop()
