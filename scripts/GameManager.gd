extends Node

@onready var tilemap_manager: TilemapManager
@onready var player: Player
@onready var day_manager: DayCycleManager

var debug_flags = {
	"skip_main_menu": true,     # Skip the main menu, start the game immediately
	"skip_intro_dialogue": true # Skip the BeeFairy1 dialogue that plays on game start
}

var paused: bool = false:
	set(value):
		paused = value
		get_tree().paused = paused
		if paused:
			game_paused.emit()
		else:
			game_unpaused.emit()

signal game_started
signal game_paused
signal game_unpaused

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if OS.has_feature("editor"):
		# Editor build, so we should notify about enabled debug flags
		for flag in debug_flags:
			if debug_flags[flag] == true:
				print("[DEBUG] Debug flag '", flag, "' is enabled.")
	else:
		# Not an editor build, so set all debug flags to false
		print("[DEBUG] Not running in the editor. All debug flags have been disabled.")
		for flag in debug_flags:
			debug_flags[flag] = false


func initialize():
	tilemap_manager = $"../MainScene/%Tilemap"
	player = $"../MainScene/%Player"
	day_manager = $"../MainScene/%DayCycleManager"
	game_started.emit()
