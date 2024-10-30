extends Control

@export var time_for_press_to_become_hold: float = 0.1

@onready var ui: Control
@onready var pause_menu: PauseMenu
@onready var camera: PanCamera

enum interactionStates {SELECTION, MOVEMENT, RESOURCE_TRANSFER}

var dialogue_open: bool = false
var ingame: bool = false

var curr_interaction_state: interactionStates = interactionStates.SELECTION

var right_down_timestamp: float

var selected_object: GridObject:
	set(new_object):
		if selected_object == new_object:
			return
		
		# We only want to deselect the old object if it isn't null
		if is_instance_valid(selected_object):
			selected_object.set_selected(false)
		
		# We only want to select the new object if it isn't null
		if is_instance_valid(new_object):
			new_object.set_selected(true)
		
		var old_selection = selected_object
		selected_object = new_object
		
		selection_changed.emit(old_selection, selected_object)

signal selection_changed(old_selection: GridObject, new_selection: GridObject)

signal dialogue_started
signal dialogue_ended

var is_dragging: bool

func initialize	():
	ui = $"../MainScene/CanvasLayer/%UI"
	pause_menu = $"../MainScene/CanvasLayer/%UI/%PauseMenu"
	camera = $"../MainScene/Player/%Player/%Camera2D"
	
	is_dragging = false
	ingame = true
	
	# TODO connect set_energy_display_max to TreeManager.stage_completed signal
	
	Dialogic.timeline_started.connect(_on_dialogue_started)
	Dialogic.timeline_ended.connect(_on_dialogue_ended)


func deinitialize():
	ingame = false


func _unhandled_input(event):
	# If Dialogic is open, camera controls are disabled
	if (not ingame) or pause_menu.open or dialogue_open:
		return
	
	
	# Zoom input
	if event.is_action_pressed("zoom_in"):
		camera.zoom_in()
	elif event.is_action_pressed("zoom_out"):
		camera.zoom_out()
	
	
	if event is InputEventMouseButton:
	
		if event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_grid_pos = GameManager.tilemap_manager.global_to_grid(get_global_mouse_position())
			
			# if the player misses the grid, treat as cancelled input
			if mouse_grid_pos == null:
				_on_cancel_input()
			else:
				if event.is_pressed():
					_on_base_tile_clicked(mouse_grid_pos)
				elif event.is_released():
					_on_base_tile_released(mouse_grid_pos)
			
			get_viewport().set_input_as_handled()
	
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			is_dragging = false
			if event.is_pressed():
				right_down_timestamp = Time.get_ticks_msec()
				is_dragging = true
			elif event.is_released():
				# if right click is released quickly (not a hold) cancel current state
				if Time.get_ticks_msec() < (right_down_timestamp + (time_for_press_to_become_hold * 1000)):
					set_interaction_state(interactionStates.SELECTION)
			
			get_viewport().set_input_as_handled()
	
	elif event is InputEventMouseMotion and is_dragging:
		camera.pan(event.relative)
		get_viewport().set_input_as_handled()


# called on state change for visual changes without click context
func set_interaction_state(target_interaction_state: interactionStates):
	# deactivating previous interaction state
	match curr_interaction_state:
		interactionStates.SELECTION:
			pass
		interactionStates.MOVEMENT:
			# TODO turn off arrow
			pass
		interactionStates.RESOURCE_TRANSFER:
			# TODO return grabbed resource to its popup gridobject
			pass
	
	curr_interaction_state = target_interaction_state
	
	# activating new interaction state
	match target_interaction_state:
		interactionStates.SELECTION:
			pass
		interactionStates.MOVEMENT:
			# TODO turn on arrow
			pass
		interactionStates.RESOURCE_TRANSFER:
			pass


# TODO add _on_resource_clicked() (and maybe _on_resource_released()?)


# TODO ROUTE ALL GRID OBJECT BUTTONS TO CALL BOTH OF THE FOLLOWING
func _on_grid_object_clicked(target_object: GridObject):
	match curr_interaction_state:
		interactionStates.SELECTION:
			selected_object = target_object
			if selected_object is Entity:
				set_interaction_state(interactionStates.MOVEMENT)
			pass
		interactionStates.MOVEMENT:
			# selected object *should* be an entity if the code reaches this point
			GameManager.player.try_move(selected_object, target_object.grid_coordinates)
			set_interaction_state(interactionStates.SELECTION)
			pass
		interactionStates.RESOURCE_TRANSFER:
			# this is theoretically unreachable and here for posterity's sake
			pass


func _on_grid_object_released(target_object: GridObject):
	match curr_interaction_state:
		interactionStates.SELECTION:
			# do nothing
			pass
		interactionStates.MOVEMENT:
			# do nothing
			pass
		interactionStates.RESOURCE_TRANSFER:
			# TODO tell player to try transfer to this grid object
			pass


func _on_base_tile_clicked(target_coords: Vector2i):
	match curr_interaction_state:
		interactionStates.SELECTION:
			# TODO select InteractableTile contained on this tile
			pass
		interactionStates.MOVEMENT:
			GameManager.player.try_move(selected_object, target_coords)
			selected_object = null
			set_interaction_state(interactionStates.SELECTION)
		interactionStates.RESOURCE_TRANSFER:
			# this is theoretically unreachable and here for posterity's sake
			pass


func _on_base_tile_released(target_coords: Vector2i):
	match curr_interaction_state:
		interactionStates.SELECTION:
			# do nothing
			pass
		interactionStates.MOVEMENT:
			# do nothing
			pass
		interactionStates.RESOURCE_TRANSFER:
			# TODO if InteractableTile at target_coords, ask player to try transfer to that InteractableTile
			# TODO else, ask player to try drop at those target_coords
			pass


func _on_cancel_input():
	selected_object = null
	set_interaction_state(interactionStates.SELECTION)


func _on_dialogue_started():
	dialogue_open = true
	dialogue_started.emit()


func _on_dialogue_ended():
	dialogue_open = false
	dialogue_ended.emit()


# TODO energy visual stuff
func set_energy_display_amount(new_amount: int):
	pass


# TODO energy visual stuff
func set_energy_display_max(new_max: int):
	pass
