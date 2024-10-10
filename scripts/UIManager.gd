extends Control

@onready var ui: Control = $"../MainScene/CanvasLayer/%UI"
@onready var pause_menu: PauseMenu = $"../MainScene/CanvasLayer/%UI/%PauseMenu"

var mouse_over_ui: bool = false


func _ready():
	ui.mouse_entered.connect(func(): mouse_over_ui = true)
	ui.mouse_exited.connect(func(): mouse_over_ui = false)


func _process(_delta):
	print(mouse_over_ui)
