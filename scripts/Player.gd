class_name Player
extends Node2D

@export var camera: PanCamera

var selected_object: GridObject:
	set(new_object):
		if selected_object == new_object:
			return
		
		# We only want to deselect the old object if it isn't null
		if selected_object:
			selected_object.set_selected(false)
		
		# We only want to select the new object if it isn't null
		if new_object:
			new_object.set_selected(true)
		
		selected_object = new_object
		
		selection_changed.emit(selected_object)

signal selection_changed(new_selection: GridObject)


func _ready():
	camera.tile_clicked.connect(_on_tile_clicked)
	
	# debug
	var mole_hill_res = Resources.find("objects")["mole_hill"]
	
	var mole_hill: MoleHill = GameManager.tilemap_manager.create_object_at_coords(mole_hill_res, Vector2i(5, 6))
	
	#item_pile.deposit(Slot.ResourceType.HONEY, 2)


func _on_tile_clicked(coordinates: Vector2i):
	if selected_object is Entity:
		selected_object.set_new_target(coordinates)
