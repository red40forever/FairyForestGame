extends FmodBankLoader

var music_emitter: MusicEmitter
var i = 0
var param = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_emitter = MusicEmitter.new()
	music_emitter.event_guid = "{dd4a22dd-c9bd-4f7e-8abc-6427a57f0be4}"
	music_emitter.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(i > 5):
		i = 0
		music_emitter.set_param("volume", -1)
		print("swap")
	else:
		i += delta

func _exit_tree():
	music_emitter.stop()
