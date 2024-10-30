class_name Player
extends Node2D

@export var camera: PanCamera

func _ready():
	# HACKY! who cares
	GameManager.initialize()
	
	GameManager.day_manager.day_changed.connect(_on_day_changed)

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
	
	if !GameManager.debug_flags["skip_intro_dialogue"]:
		Dialogic.start("BeeFairy1")


func try_move_entity(selected_entity: Entity, target_pos: Vector2i):
	selected_entity.set_new_target_position(target_pos)


func _on_day_changed():
	var day_count = GameManager.day_manager.day_count
	if day_count == 1:
		Dialogic.start("BeeFairy2")
	elif day_count == 2:
		Dialogic.start("BeeFairy3")
	elif day_count == 3:
		Dialogic.start("BeeFairy4")


func try_move(to_move: Entity):
	pass


func try_transfer(destination: GridObject):
	pass


func _exit_tree():
	GameManager.deinitialize()
