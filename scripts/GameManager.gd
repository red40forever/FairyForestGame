extends Node

@onready var tilemap_manager = $"../MainScene/%Tilemap"
@onready var player = $"../MainScene/%Player"

signal day_changed()
