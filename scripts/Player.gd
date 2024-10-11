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
		
		var old_selection = selected_object
		selected_object = new_object
		
		selection_changed.emit(old_selection, selected_object)

signal selection_changed(old_selection: GridObject, new_selection: GridObject)


func _ready():
	camera.tile_clicked.connect(_on_tile_clicked)
	
	#Dialogic.start("IntroDialogue")
	
	# Create initial tiles
	var beehive_res = Resources.find("objects")["beehive"]
	var bee_res = Resources.find("objects")["bee"]
	var flower_res = Resources.find("objects")["flower"]
	
	var beehive: Beehive = GameManager.tilemap_manager.create_object_at_coords(beehive_res, Vector2i(5, 7))
	var bee1: Bee = GameManager.tilemap_manager.create_object_at_coords(bee_res, Vector2i(4, 4))
	var bee2: Bee = GameManager.tilemap_manager.create_object_at_coords(bee_res, Vector2i(4, 7))
	var flower: Flower = GameManager.tilemap_manager.create_object_at_coords(flower_res, Vector2i(4, 10))
	beehive.add_entity(bee1)
	beehive.add_entity(bee2)
	#item_pile.deposit(Slot.ResourceType.HONEY, 2)

func _on_tile_clicked(coordinates: Vector2i):
	if selected_object is Entity:
		selected_object.set_new_target(coordinates)
