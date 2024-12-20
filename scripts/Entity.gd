class_name Entity
extends SelectableGridObject

@export_group("Attributes")
@export var entity_attributes: EntityAttributes
@export var home_tile_name: String = "HomeTile"

@export_group("Interactions")
@export var carryable_resources: Array[Slot.ResourceType]
@export var max_storage: int = 1
@export var effortless_tiles: Array = [""] # THESE SHOULD BE STRINGS

@export_group("References")
@export var slot_display: SlotDisplay

var interactions_completed: int = 0
var idle: bool = true
var slot: Slot

# Movement
var target: Vector2
var target_map_coords: Vector2i
var home: HomeTile
var tween: Tween = null

var flipped = false
var moving = false

signal return_home(entity: Entity, slot: Slot)
#signal deposit_resources(resources_to_deposit: Slot)

func _ready():
	super()
	
	target = self.position
	target_map_coords = grid_coordinates
	
	slot = Slot.new(carryable_resources, max_storage)
	
	if slot_display:
		slot_display.displayed_slot = slot
		
		# TODO: Consolidate hover logic into shared base class
		slot_display.mouse_entered.connect(on_hover_start)
		slot_display.mouse_exited.connect(on_hover_finish)
	else:
		push_warning("Entity '", name, "' does not have a SlotDisplay.")
	
	GameManager.player.selection_changed.connect(_on_selection_changed)
	
	_do_spawn_animation()

func _process(_delta: float) -> void:
	if not idle:
		if interactions_completed >= entity_attributes.max_interactions:
			set_new_target_position(home.grid_coordinates)
		#self.grid_coordinates = GameManager.tilemap_manager.ground_layer.local_to_map(self.position)


func set_new_target(new_target: InteractableGridObject):
	set_new_target_position(new_target.grid_coordinates)


func set_new_target_position(new_target: Vector2i):
	if new_target == Vector2i(target_map_coords):
		return
	
	var placement = GameManager.tilemap_manager.placement_helper
	if !placement.is_tile_accessible(new_target):
		return
	
	idle = false
	
	# convert tilemap coords into world coords
	target_map_coords = new_target
	target = GameManager.tilemap_manager.ground_layer.map_to_local(new_target)
	
	# Create tween that moves sprite to target
	var direction := target - self.position
	direction = direction.normalized()
	
	# Remove old tween if it was present,
	# ex. if a new target is set before the old tween finished
	if tween != null:
		tween.kill()
		
	# Create and set up the new tween
	var distance = (target - position).length()
	tween = get_tree().create_tween()
	var tween_duration = distance / entity_attributes.speed
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", target, tween_duration)
	tween.finished.connect(_on_tween_finished)
	moving = true
	
	# Visual flip depending on direction
	flipped = target.x <= position.x
	main_sprite.flip_h = flipped

func set_home(new_home: HomeTile) -> void:
	new_home.add_entity(self)

func set_attributes(new_attributes: EntityAttributes) -> void:
	entity_attributes = new_attributes

# When tween is finished, entity has stopped moving.
func _on_tween_finished():
	tween = null
	moving = false
	grid_coordinates = target_map_coords
	
	if GameManager.player.selected_object == self:
		GameManager.player.selected_object = null
	
	# Determine what type of tile we've stopped at, do stuff accordingly
	var mgr = GameManager.tilemap_manager
	var map_coords = grid_coordinates
	var objects = mgr.get_objects_at(map_coords)
	
	if len(objects) == 1:
		interact_with_empty_tile()
		return
	
	# If valid object type, do stuff
	for object in objects:
		if object is InteractableGridObject:
			try_interact_with_object(object)

# override in child classes
func interact_with_empty_tile():
	pass

func try_interact_with_object(object: InteractableGridObject) -> bool:
	if interactions_completed < entity_attributes.max_interactions:
		var inter = object.request_interaction(slot)
		if inter:
			# See if this interaction was effortless
			var found_match = false
			for string in effortless_tiles:
				var obj_string = object.get_class_name()
				if obj_string == string:
					found_match = true
			if not found_match:
				interactions_completed += 1
			return true
	elif object is HomeTile or object.get_class_name() == home_tile_name:
		return_home.emit(self, slot)
	return false

func get_class_name(): return "Entity"


func despawn():
	is_despawned = true
	despawned.emit()
	
	await _do_despawn_animation()

	queue_free()


# TODO: Consolidate hover logic into shared base class
func on_hover_start():
	super()
	if slot_display:
		slot_display.set_open(true)


func on_hover_finish():
	super()
	if slot_display:
		slot_display.set_open(false)


func _on_selection_changed(old_selection: GridObject, new_selection: GridObject):
	if old_selection == self and new_selection is HomeTile:
		set_new_target_position(new_selection.grid_coordinates)
		GameManager.player.selected_object = null


func _do_spawn_animation():
	var spawn_tween = get_tree().create_tween()
	spawn_tween.set_ease(Tween.EASE_OUT)
	spawn_tween.set_trans(Tween.TRANS_CUBIC)
	spawn_tween.tween_property(self, "scale", scale, 0.25)
	scale = Vector2.ZERO


func _do_despawn_animation():
	var despawn_tween = get_tree().create_tween()
	despawn_tween.set_ease(Tween.EASE_OUT)
	despawn_tween.set_trans(Tween.TRANS_QUAD)
	despawn_tween.tween_property(self, "scale", Vector2.ZERO, 0.25)
	
	await despawn_tween.finished
