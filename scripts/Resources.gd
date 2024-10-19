## NOTE: This class is for Godot asset resources. See Slot for in-game resources.
class_name Resources

static var resources: Dictionary = {
	"objects": {
		"bee":       preload("res://objects/bee_obj.tres"),
		"mole":      preload("res://objects/mole_obj.tres"),
		"beehive":   preload("res://objects/beehive_obj.tres"),
		"mole_hill": preload("res://objects/mole_hill_obj.tres"),
		"item_pile": preload("res://objects/item_pile_obj.tres"),
		"flower":    preload("res://objects/flower_obj.tres"),
		"mushroom":  preload("res://objects/mushroom_obj.tres")
	},
	"ui_resource_sprites": {
		Slot.ResourceType.HONEY:    preload("res://textures/icon_honey.png"),
		Slot.ResourceType.POLLEN:   preload("res://textures/icon_pollen.png"),
		Slot.ResourceType.MUSHROOM: preload("res://textures/icon_mushroom.png"),
		Slot.ResourceType.SPORE:    preload("res://textures/icon_spore.png")
	},
	# TODO: figure out why using load() and a cast is necessary
	"entity_attributes": {
		"bee":  load("res://objects/bee_entity_attributes.tres") as EntityAttributes,
		"mole": load("res://objects/mole_entity_attributes.tres") as EntityAttributes
	}
}


static func find(key):
	var temp2 = resources
	var temp = resources.get(key)
	return temp
