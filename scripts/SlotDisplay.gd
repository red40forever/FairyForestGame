extends Node2D

var displayed_slot: Slot

var open: bool = false
var animating: bool = false

signal animation_finished(open: bool)


func _ready():
	var accepted_types: Array[Slot.ResourceType] = [
		Slot.ResourceType.HONEY,
		Slot.ResourceType.POLLEN
	]
	displayed_slot = Slot.new(accepted_types, 5)
	displayed_slot.add_resource(Slot.ResourceType.HONEY, 2)
	displayed_slot.add_resource(Slot.ResourceType.POLLEN, 3)
	
	displayed_slot.resource_added.connect(_on_slot_resource_added)
	displayed_slot.resource_removed.connect(_on_slot_resource_removed)


func animate_display_open():
	if open:
		return
	
	animating = true
	open = true
	
	var padding = 10
	var stored_resource_count = displayed_slot.stored_resources.size()
	var starting_position = Vector2(
		0,
		-round(stored_resource_count * padding),
	)
	var resource_sprites: Array[Sprite2D] = []
	for resource: Slot.ResourceType in displayed_slot.stored_resources:
		var resource_count = displayed_slot.stored_resources[resource]
		starting_position.x = round(-((padding * resource_count) / 2) + padding * 0.5)
		#starting_position.x = 0
		for i in range(resource_count):
			var resource_sprite = _create_resource_sprite(resource)
			resource_sprite.scale = Vector2.ZERO
			resource_sprite.position = starting_position
			resource_sprites.append(resource_sprite)
			
			starting_position.x += padding
		starting_position.y += padding
	
	for resource_sprite in resource_sprites:
		var target_position = resource_sprite.position
		resource_sprite.position = Vector2.ZERO
		
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(resource_sprite, "position", target_position, 0.1)
		tween.set_parallel()
		tween.tween_property(resource_sprite, "scale", Vector2.ONE, 0.1)
		
		await get_tree().create_timer(0.05).timeout
	
	animating = false
	animation_finished.emit(true)


func animate_display_close():
	if !open:
		return
	
	animating = true
	open = false
	
	print("closing children:")
	for child in get_children():
		print(child.name)
	
	for child: Node2D in get_children():
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(child, "position", Vector2.ZERO, 0.1)
		tween.set_parallel()
		tween.tween_property(child, "scale", Vector2.ZERO, 0.1)
		tween.set_parallel(false)
		tween.tween_callback(
			func():
				if is_instance_valid(child):
					child.queue_free()
		)
		
		#await get_tree().create_timer(0.05).timeout
		
	animating = false
	animation_finished.emit(false)


func _on_slot_resource_added(resource: Slot.ResourceType, count: int):
	pass


func _on_slot_resource_removed(resource: Slot.ResourceType, count: int):
	pass


func _create_resource_sprite(resource: Slot.ResourceType) -> Sprite2D:
	var resource_sprite = Sprite2D.new()
	var sprites = Resources.find("ui_resource_sprites")
	add_child(resource_sprite)
	resource_sprite.texture = sprites[resource]
	resource_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	return resource_sprite
