class_name Resources

static var resources: Dictionary = {
	"ui_resource_sprites": {
		# Key corresponds to Slot.ResourceType enum
		0: preload("res://textures/icon_honey.png"),
		1: preload("res://textures/icon_pollen.png")
	}
}


static func find(key):
	return resources.get(key)
