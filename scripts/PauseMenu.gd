class_name PauseMenu
extends Control


enum State {
	CLOSED,
	PAUSED_MAIN,
	PAUSED_QUIT_CONFIRM
}
var state: State


func _ready():
	# Don't stop processing on pause
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	set_open(false)


func _process(_delta):
	if Input.is_action_just_pressed("pause_game"):
		if state == State.CLOSED:
			set_state(State.PAUSED_MAIN)
			GameManager.paused = true
		else:
			set_state(State.CLOSED)
			GameManager.paused = false


func set_state(new_state: State):
	state = new_state
	if state == State.CLOSED:
		visible = false
	elif state == State.PAUSED_MAIN:
		visible = true
		%PausePanel.visible = true
		%QuitConfirmPanel.visible = false
	elif state == State.PAUSED_QUIT_CONFIRM:
		visible = true
		%PausePanel.visible = false
		%QuitConfirmPanel.visible = true


func set_open(new_open: bool):
	if new_open:
		set_state(State.PAUSED_MAIN)
	else:
		set_state(State.CLOSED)


func _on_yes_button_pressed():
	get_tree().quit()


func _on_no_button_pressed():
	set_state(State.CLOSED)
	GameManager.paused = false


func _on_quit_button_pressed():
	set_state(State.PAUSED_QUIT_CONFIRM)
