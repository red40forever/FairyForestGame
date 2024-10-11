extends Node

@export var menuMusicEvent: EventAsset
@export var gameplayMusicEvent: EventAsset
@export var dialogueMusicEventBee: EventAsset
@export var dialogueMusicEventMole: EventAsset
@export var ambienceEvent: EventAsset	

enum song {MENU, GAMEPLAY, DIALOGUE_BEE, DIALOGUE_MOLE}

var musicInstance: EventInstance
var ambienceInstance: EventInstance

var beat_callable: Callable = Callable(self, "beat_callback")

var beat_counter = 0

var bee_count = 0
var mole_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.tilemap_manager.grid_object_created.connect(add_entity)
	GameManager.tilemap_manager.grid_object_deleted.connect(remove_entity)
	ambienceInstance = FMODRuntime.create_instance(ambienceEvent)
	ambienceInstance.start()

func play(songName: song):
	if(musicInstance != null):
		musicInstance.stop(FMODStudioModule.FMOD_STUDIO_STOP_ALLOWFADEOUT)
		musicInstance.release()

	match songName:
		song.MENU:
			musicInstance = FMODRuntime.create_instance(menuMusicEvent)
		song.GAMEPLAY:
			musicInstance = FMODRuntime.create_instance(gameplayMusicEvent)
			beat_counter = 0
			musicInstance.set_callback(beat_callable, FMODStudioModule.FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_BEAT)
		song.DIALOGUE_BEE:
			musicInstance = FMODRuntime.create_instance(dialogueMusicEventBee)
		song.DIALOGUE_MOLE:
			musicInstance = FMODRuntime.create_instance(dialogueMusicEventMole)

	musicInstance.start()

func setParameter(parameterName: String, value: Variant):
	FMODStudioModule.get_studio_system().set_parameter_by_name(parameterName, value, false)

func beat_callback(args):
	if args.properties.beat:
		beat_counter += 1
		if(beat_counter == 5):
			beat_counter = 1
			FMODStudioModule.get_studio_system().set_parameter_by_name("Bee Count", clamp(bee_count, 0, 5), false)
			FMODStudioModule.get_studio_system().set_parameter_by_name("Mole Count", clamp(mole_count, 0, 3), false)

func add_entity(grid_object, coords):
	if (grid_object is Bee):
		bee_count += 1
	if (grid_object is Mole):
		mole_count += 1

func remove_entity(grid_object, coords):
	if (grid_object is Bee):
		bee_count -= 1
	if (grid_object is Mole):
		mole_count -= 1
