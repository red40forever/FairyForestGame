## NOTE: This class is for Godot asset resources. See Slot for in-game resources.
class_name Resources

static var resources: Dictionary = {
	"objects": {
		"bee": preload("res://objects/bee_obj.tres"),
		"mole": preload("res://objects/mole_obj.tres"),
		"beehive": preload("res://objects/beehive_obj.tres"),
		"item_pile": preload("res://objects/item_pile_obj.tres")
	},
	"ui_resource_sprites": {
		# Key corresponds to Slot.ResourceType enum
		0: preload("res://textures/icon_honey.png"),
		1: preload("res://textures/icon_pollen.png")
	}
}


static func find(key):
	return resources.get(key)
