extends Node

@onready var tilemap_manager: TilemapManager
@onready var player: Player
@onready var day_manager: DayCycleManager

var paused: bool = false:
	set(value):
		paused = value
		get_tree().paused = paused

signal game_started


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func initialize():
	tilemap_manager = $"../MainScene/%Tilemap"
	player = $"../MainScene/%Player"
	day_manager = $"../MainScene/%DayCycleManager"
	game_started.emit()
