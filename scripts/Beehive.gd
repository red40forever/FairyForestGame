class_name Beehive
extends HomeTile

func _ready():
	entity_grid_object_attributes = Resources.find("objects")["bee"]
	entity_attributes = Resources.find("entity_attributes")["bee"]
	resource_type = Slot.ResourceType.POLLEN
	product_type = Slot.ResourceType.HONEY
	selected_withdraw_type = Slot.ResourceType.POLLEN
	super()
	if randf() > 0.5:
		main_sprite.flip_h = true
	
	slot.resource_count_updated.connect(_on_resource_count_updated)


func _on_resource_count_updated(resource_type: Slot.ResourceType, old_count: int, new_count: int):
	if resource_type == Slot.ResourceType.HONEY && new_count == 2:
		Dialogic.start("2HoneyInHive")


func get_class_name(): return "Beehive"
