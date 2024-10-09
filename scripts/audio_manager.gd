extends Node

@export var overworldMusicEventA: EventAsset
@export var overworldMusicEventB: EventAsset
@export var DialogueMusicEventBee: EventAsset
@export var DialogueMusicEventMole: EventAsset

enum song {GAMEPLAY_A, GAMEPLAY_B, DIALOGUE_BEE, DIALOGUE_MOLE}

var musicInstance: EventInstance

var teststate = 0
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("audio 1")
	play(song.GAMEPLAY_A)
	teststate = 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if(teststate == 1 and time > 3):
		print("audio 2")
		setParameter("volume", -1)
		teststate = 2
	if(teststate == 2	 and time > 6):
		print("audio 3")
		setParameter("volume", 1)
		teststate = 3
		

func play(songName: song):
	if(musicInstance != null):
		musicInstance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
		musicInstance.release()
	
	match songName:
		song.GAMEPLAY_A:
			musicInstance = FMODRuntime.create_instance(overworldMusicEventA)
		song.GAMEPLAY_B:
			musicInstance = FMODRuntime.create_instance(overworldMusicEventB)
		song.DIALOGUE_BEE:
			musicInstance = FMODRuntime.create_instance(DialogueMusicEventBee)
		song.DIALOGUE_MOLE:
			musicInstance = FMODRuntime.create_instance(DialogueMusicEventMole)

	musicInstance.start()
	
func setParameter(parameterName: String, value: Variant):
	FMODStudioModule.get_studio_system().set_parameter_by_name(parameterName, value, false)
	
