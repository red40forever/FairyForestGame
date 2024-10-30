class_name Player
extends Node2D

@export var camera: PanCamera

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


func _ready():
	# HACKY! who cares
	GameManager.initialize()
	UIManager.initialize()
	
	GameManager.day_manager.day_changed.connect(_on_day_changed)
	
	camera.tile_clicked.connect(_on_tile_clicked)
	
	_initialize_starter_grid_objects()
	
	if !GameManager.debug_flags["skip_intro_dialogue"]:
		Dialogic.start("BeeFairy1")


func _initialize_starter_grid_objects():
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
	flower.slot.add_resource(Slot.ResourceType.POLLEN, 1)
	#item_pile.deposit(Slot.ResourceType.HONEY, 2)


func set_target_of_selected_entity(target_object: InteractableGridObject):
	if selected_object is Entity:
		selected_object.set_new_target(target_object)


func _on_tile_clicked(coordinates: Vector2i):
	if is_instance_valid(selected_object):
		if selected_object is Entity:
			selected_object.set_new_target_position(coordinates)


func _on_day_changed():
	var day_count = GameManager.day_manager.day_count
	if day_count == 1:
		Dialogic.start("BeeFairy2")
	elif day_count == 2:
		Dialogic.start("BeeFairy3")
	elif day_count == 3:
		Dialogic.start("BeeFairy4")
