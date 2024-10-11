extends Node

@export var menuMusicEvent: EventAsset
@export var overworldMusicEventA: EventAsset
@export var overworldMusicEventB: EventAsset
@export var DialogueMusicEventBee: EventAsset
@export var DialogueMusicEventMole: EventAsset

enum song {MENU, GAMEPLAY_A, GAMEPLAY_B, DIALOGUE_BEE, DIALOGUE_MOLE}

var musicInstance: EventInstance

var beat_callable: Callable = Callable(self, "beat_callback")

var beat_counter = 0

var bee_count = 0
var mole_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.tilemap_manager.grid_object_created.connect(add_entity)
	GameManager.tilemap_manager.grid_object_deleted.connect(remove_entity)

func play(songName: song):
	if(musicInstance != null):
		musicInstance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
		musicInstance.release()

	var shouldCallback = false

	match songName:
		song.MENU:
			musicInstance = FMODRuntime.create_instance(menuMusicEvent)
		song.GAMEPLAY_A:
			musicInstance = FMODRuntime.create_instance(overworldMusicEventA)
			shouldCallback = true
		song.GAMEPLAY_B:
			musicInstance = FMODRuntime.create_instance(overworldMusicEventB)
			shouldCallback = true
		song.DIALOGUE_BEE:
			musicInstance = FMODRuntime.create_instance(DialogueMusicEventBee)
		song.DIALOGUE_MOLE:
			musicInstance = FMODRuntime.create_instance(DialogueMusicEventMole)

	if shouldCallback:
		beat_counter = 0
		musicInstance.set_callback(beat_callable, FMODStudioModule.FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_BEAT)

	musicInstance.start()

func setParameter(parameterName: String, value: Variant):
	FMODStudioModule.get_studio_system().set_parameter_by_name(parameterName, value, false)

func beat_callback(args):
	if args.properties.beat:
		beat_counter += 1
		if(beat_counter == 5):
			beat_counter = 1
			# TODO make sure that switching songs makes it swap at the top of the bar bar
			FMODStudioModule.get_studio_system().set_parameter_by_name("Bee Count", bee_count, false)
			FMODStudioModule.get_studio_system().set_parameter_by_name("Mole Count", mole_count, false)

func add_entity(grid_object, coords):
	pass # TODO check bee/mole and increment based on that

func remove_entity(grid_object, coords):
	pass # TODO check bee/mole and decrement based on that
