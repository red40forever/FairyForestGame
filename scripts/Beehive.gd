class_name Beehive
extends HomeTile

func _ready():
	entity_grid_object_attributes = Resources.find("objects")["bee"]
	entity_attributes = Resources.find("entity_attributes")["bee"]
	resource_type = Slot.ResourceType.POLLEN
	product_type = Slot.ResourceType.HONEY
	super()
	if randf() > 0.5:
		main_sprite.flip_h = true

func get_class_name(): return "Beehive"
