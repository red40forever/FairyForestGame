@tool
class_name ResourceButton
extends Button

@export var resource_type: Slot.ResourceType:
	set(value):
		resource_type = value
		icon = Resources.find("ui_resource_sprites")[resource_type]


func _init(p_resource_type: Slot.ResourceType):
	resource_type = p_resource_type
	
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	mouse_default_cursor_shape = CURSOR_POINTING_HAND
	
	# Sorry
	add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	add_theme_stylebox_override("disabled_mirrored", StyleBoxEmpty.new())
	add_theme_stylebox_override("disabled", StyleBoxEmpty.new())
	add_theme_stylebox_override("hover_pressed_mirrored", StyleBoxEmpty.new())
	add_theme_stylebox_override("hover_pressed", StyleBoxEmpty.new())
	add_theme_stylebox_override("hover_mirrored", StyleBoxEmpty.new())
	add_theme_stylebox_override("hover", StyleBoxEmpty.new())
	add_theme_stylebox_override("pressed_mirrored", StyleBoxEmpty.new())
	add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
	add_theme_stylebox_override("normal_mirrored", StyleBoxEmpty.new())
	add_theme_stylebox_override("normal", StyleBoxEmpty.new())
