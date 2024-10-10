@tool
class_name ResourceSprite
extends Sprite2D

@export var resource_type: Slot.ResourceType:
	set(value):
		resource_type = value
		texture = Resources.find("ui_resource_sprites")[resource_type]


func _init(p_resource_type: Slot.ResourceType):
	resource_type = p_resource_type
