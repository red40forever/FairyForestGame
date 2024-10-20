class_name PauseMenu
extends Control

# TODO: Re-enable main pause menu when it's done
var open: bool = false

var can_pause: bool = true


func _ready():
	# Don't stop processing on pause
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	Dialogic.timeline_started.connect(_on_dialogue_started)
	Dialogic.timeline_ended.connect(_on_dialogue_ended)
	
	visible = false

func _on_dialogue_started():
	can_pause = false


func _on_dialogue_ended():
	can_pause = true


func _process(_delta):
	if !can_pause:
		return
	
	if Input.is_action_just_pressed("pause_game"):
		set_open(!open)


func set_open(new_open: bool):
	open = new_open
	if open:
		visible = true
		%QuitConfirmDialog.animate_open()
		GameManager.paused = true
	else:
		%QuitConfirmDialog.animate_close()
		GameManager.paused = false
		await %QuitConfirmDialog.animation_finished
		visible = false


func _on_yes_button_pressed():
	get_tree().quit()


func _on_no_button_pressed():
	set_open(false)
	GameManager.paused = false
