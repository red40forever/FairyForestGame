class_name SlotDisplay
extends Control

var displayed_slot: Slot:
	set(value):
		displayed_slot = value
		_update_displayed_slot(value)

var horizontal_containers = { }

var open: bool = false
var animating: bool = false
var original_position: Vector2

var tween: Tween

signal resource_clicked(resource: Slot.ResourceType)
# unused signal animation_finished(open: bool)


func _ready():	
	# For open/close animation
	original_position = position
	visible = false


func set_open(new_open: bool):
	if new_open && !open:
		animate_display_open.call_deferred()
	elif !new_open && open:
		animate_display_close.call_deferred()
	open = new_open


func animate_display_open():
	if tween:
		tween.kill()
	
	position = original_position + Vector2(0, 4)
	
	# Only bother displaying if the slot has resources in it
	if displayed_slot.total_resource_count > 0:
		visible = true
		
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", original_position, 0.1)
	tween.set_parallel()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)


func animate_display_close():
	if tween:
		tween.kill()
		
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", position + Vector2(0, 4), 0.1)
	tween.set_parallel()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 0), 0.1)
	tween.set_parallel(false)
	tween.tween_callback(func(): visible = false)


func _update_displayed_slot(p_displayed_slot: Slot):
	for child in %VBoxContainer.get_children():
		child.queue_free()
	
	# Create a horizontal container for each resource
	for resource: Slot.ResourceType in p_displayed_slot.stored_resources:
		var horizontal_container = HBoxContainer.new()
		horizontal_container.alignment = BoxContainer.ALIGNMENT_CENTER
		%VBoxContainer.add_child(horizontal_container)
		horizontal_containers[resource] = horizontal_container
		
		# If there are no resources in the horizontal container, hide it
		var resource_count = p_displayed_slot.get_resource_count(resource)
		horizontal_container.visible = false
		
		for i in range(resource_count):
			var button = _create_resource_button(resource)
			horizontal_container.add_child(button)
	
	p_displayed_slot.resource_count_updated.connect(_on_slot_resource_count_updated)


func _add_resource_icons(resource: Slot.ResourceType, count: int):
	var horizontal_container: HBoxContainer = horizontal_containers[resource]
	for i in range(count):
		var button = _create_resource_button(resource)
		horizontal_containers[resource].add_child(button)
	
	horizontal_container.visible = true
	
	if open:
		visible = true


func _remove_resource_icons(resource: Slot.ResourceType, count: int):
	# var children_to_delete: Array[TextureRect] = []
	var horizontal_container: HBoxContainer = horizontal_containers[resource]
	for i in range(count):
		var child_to_delete = horizontal_container.get_child(0)
		child_to_delete.queue_free()
	
	if horizontal_container.get_children().size() - count == 0:
		horizontal_container.visible = false
	
	if displayed_slot.total_resource_count == 0:
		visible = false


func _on_slot_resource_count_updated(resource: Slot.ResourceType, old_count: int, new_count: int):
	var count_change = new_count - old_count
	if count_change > 0:
		_add_resource_icons(resource, count_change)
	else:
		_remove_resource_icons(resource, abs(count_change))


func _on_resource_button_pressed(resource: Slot.ResourceType):
	resource_clicked.emit(resource)


func _create_resource_button(resource: Slot.ResourceType, should_use_pressed_signal: bool = true) -> Button:
	var button = ResourceButton.new(resource)
	
	if should_use_pressed_signal:
		button.pressed.connect(_on_resource_button_pressed.bind(resource))
	
	return button
