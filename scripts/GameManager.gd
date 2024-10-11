extends Node

@onready var tilemap_manager: TilemapManager = $"../MainScene/%Tilemap"
@onready var player: Player = $"../MainScene/%Player"
@onready var day_manager: DayCycleManager = $"../MainScene/%DayCycleManager"

var paused: bool = false:
	set(value):
		paused = value
		get_tree().paused = paused


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
