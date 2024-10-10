class_name Player
extends Node2D

@export var camera: PanCamera

var selected_object: GridObject


func _ready():
	# debug
	var item_pile_res = Resources.find("objects")["item_pile"]
	var mole_res = Resources.find("objects")["mole"]
	
	var item_pile: ItemPile = GameManager.tilemap_manager.create_object_at_coords(item_pile_res, Vector2i(4, 4))
	var mole1: Mole = GameManager.tilemap_manager.create_object_at_coords(mole_res, Vector2i(5, 5))
	var mole2: Mole = GameManager.tilemap_manager.create_object_at_coords(mole_res, Vector2i(5, 6))
	
	item_pile.deposit(Slot.ResourceType.HONEY, 2)
