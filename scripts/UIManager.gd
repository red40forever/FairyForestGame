extends Control

@onready var ui: Control
@onready var pause_menu: PauseMenu


func initialize():
	ui = $"../MainScene/CanvasLayer/%UI"
	pause_menu = $"../MainScene/CanvasLayer/%UI/%PauseMenu"
