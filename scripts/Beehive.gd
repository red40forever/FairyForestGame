class_name Beehive
extends HomeTile

func _ready():
	super()
	if randf() > 0.5:
		main_sprite.flip_h = true
	entity_grid_object_attributes = Resources.find("objects")["bee"]
	entity_attributes = Resources.find("entity_attributes")["bee"]

func get_class_name(): return "Beehive"
