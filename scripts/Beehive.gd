class_name Beehive
extends HomeTile

func _ready():
	super()
	if randf() > 0.5:
		main_sprite.flip_h = true
	entity_grid_object_attributes = Resources.find("objects")["bee"]
	entity_attributes = Resources.find("entity_attributes")["bee"]
	
	slot.resource_count_updated.connect(_on_resource_count_updated)


func _on_resource_count_updated(resource_type: Slot.ResourceType, old_count: int, new_count: int):
	if resource_type == Slot.ResourceType.HONEY && new_count == 2:
		Dialogic.start("BeeFairy4")


func get_class_name(): return "Beehive"
