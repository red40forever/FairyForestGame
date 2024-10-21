extends Control

@onready var ui: Control
@onready var pause_menu: PauseMenu

var dialogue_open: bool = false

signal dialogue_started
signal dialogue_ended


func initialize():
	ui = $"../MainScene/CanvasLayer/%UI"
	pause_menu = $"../MainScene/CanvasLayer/%UI/%PauseMenu"
	
	Dialogic.timeline_started.connect(_on_dialogue_started)
	Dialogic.timeline_ended.connect(_on_dialogue_ended)


func _on_dialogue_started():
	dialogue_open = true
	dialogue_started.emit()


func _on_dialogue_ended():
	dialogue_open = false
	dialogue_ended.emit()
