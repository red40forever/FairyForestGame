extends Control

var displayed_slot: Slot

var horizontal_containers = { }

var open: bool = false
var animating: bool = false
var original_position: Vector2

signal animation_finished(open: bool)


func _ready():
	# Testing
	var accepted_types: Array[Slot.ResourceType] = [
		Slot.ResourceType.HONEY,
		Slot.ResourceType.POLLEN
	]
	displayed_slot = Slot.new(accepted_types, 5)
	displayed_slot.add_resource(Slot.ResourceType.HONEY, 3)
	displayed_slot.add_resource(Slot.ResourceType.POLLEN, 2)
	
	displayed_slot.resource_count_updated.connect(_on_slot_resource_count_updated)
	
	# For open/close animation
	original_position = position
	visible = false
	
	# Create a horizontal container for each resource
	for resource: Slot.ResourceType in displayed_slot.stored_resources:
		var horizontal_container = HBoxContainer.new()
		horizontal_container.alignment = BoxContainer.ALIGNMENT_CENTER
		%VBoxContainer.add_child(horizontal_container)
		horizontal_containers[resource] = horizontal_container
		
		var resource_count = displayed_slot.stored_resources[resource]
		for i in range(resource_count):
			var resource_sprite = _create_resource_icon(resource)
			horizontal_container.add_child(resource_sprite)


func _process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		set_open(true)
	elif Input.is_action_just_pressed("ui_down"):
		set_open(false)
	
	if Input.is_action_just_pressed("ui_accept"):
		displayed_slot.remove_resource(Slot.ResourceType.HONEY, 1)
	if Input.is_action_just_pressed("ui_cancel"):
		displayed_slot.add_resource(Slot.ResourceType.HONEY, 1)


func set_open(new_open: bool):
	if new_open && !open:
		animate_display_open()
	elif !new_open && open:
		animate_display_close()
	open = new_open


func animate_display_open():
	position = original_position + Vector2(0, 4)
	visible = true
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", original_position, 0.1)
	tween.set_parallel()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)


func animate_display_close():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", position + Vector2(0, 4), 0.1)
	tween.set_parallel()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 0), 0.1)
	tween.set_parallel(false)
	tween.tween_callback(func(): visible = false)


func _add_resource_icons(resource: Slot.ResourceType, count: int):
	var sprite = _create_resource_icon(resource)
	var horizontal_container: HBoxContainer = horizontal_containers[resource]
	for i in range(count):
		horizontal_containers[resource].add_child(sprite)
	
	horizontal_container.visible = true


func _remove_resource_icons(resource: Slot.ResourceType, count: int):
	var children_to_delete: Array[TextureRect] = []
	var horizontal_container: HBoxContainer = horizontal_containers[resource]
	for i in range(count):
		var child_to_delete = horizontal_container.get_child(0)
		child_to_delete.queue_free()
	
	if horizontal_container.get_children().size() - count == 0:
		horizontal_container.visible = false


func _on_slot_resource_count_updated(resource: Slot.ResourceType, old_count: int, new_count: int):
	var count_change = new_count - old_count
	if count_change > 0:
		_add_resource_icons(resource, count_change)
	else:
		_remove_resource_icons(resource, abs(count_change))


func _create_resource_icon(resource: Slot.ResourceType) -> TextureRect:
	var resource_sprite = TextureRect.new()
	var sprites = Resources.find("ui_resource_sprites")
	resource_sprite.texture = sprites[resource]
	resource_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	return resource_sprite
