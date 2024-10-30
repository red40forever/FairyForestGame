class_name Entity
extends GridObject

@export_group("Attributes")
@export var entity_attributes: EntityAttributes
@export var home_tile_name: String = "HomeTile"

@export_group("Interactions")
@export var carryable_resources: Array[Slot.ResourceType]
@export var max_storage: int = 1

@export_group("References")
@export var slot_display: SlotDisplay

enum activityStates {IDLE, ACTIVE, ASLEEP}

var curr_state: activityStates
var slot: Slot

# Movement
var target: Vector2
var target_map_coords: Vector2i
var home: HomeTile
var tween: Tween = null

var flipped = false
var moving = false

func _ready():
	super()
	
	target = self.position
	target_map_coords = grid_coordinates
	
	slot = Slot.new(carryable_resources, max_storage)
	
	if slot_display:
		slot_display.displayed_slot = slot
	else:
		push_warning("Entity '", name, "' does not have a SlotDisplay.")
	
	_do_spawn_animation()

func _process(_delta: float) -> void:
	pass


func set_new_target_position(new_target: Vector2i):
	if new_target == Vector2i(target_map_coords):
		return
	
	var placement = GameManager.tilemap_manager.placement_helper
	if !placement.is_tile_accessible(new_target):
		return
	
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
	
	# Determine what type of tile we've stopped at, do stuff accordingly
	var mgr = GameManager.tilemap_manager
	var map_coords = grid_coordinates
	var objects = mgr.get_objects_at(map_coords)
	
	if len(objects) == 1:
		interact_with_empty_tile()
		return

# override in child classes
func interact_with_empty_tile():
	pass

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
