class_name Entity
extends GridObject

@export_group("Attributes")
@export var entity_attributes: EntityAttributes
@export var home_tile_name: String = "HomeTile"

enum activityStates {IDLE, ACTIVE, ASLEEP}

var curr_state: activityStates

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
	curr_state = activityStates.IDLE
	
	_do_wake_animation()


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
	tween.set_trans(Tween.TRANS_SINE)
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
	
	set_activity_state(activityStates.ASLEEP)
	
	# kind of hacky
	if curr_state == activityStates.ASLEEP and grid_coordinates == home.grid_coordinates:
		_do_sleep_animation()


func set_activity_state(new_state: activityStates):
	match new_state:
		activityStates.IDLE:
			# idk. probably shouldn't happen if this is getting called externally
			curr_state = activityStates.IDLE
		activityStates.ACTIVE:
			# also nothing????  Just needs to 
			curr_state = activityStates.ACTIVE
		activityStates.ASLEEP:
			set_new_target_position(home.grid_coordinates)
			curr_state = activityStates.ASLEEP


func is_awake() -> bool:
	return not curr_state == activityStates.ASLEEP


func get_class_name(): return "Entity"


func despawn():
	is_despawned = true
	despawned.emit()
	
	await _do_sleep_animation()

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


func _do_wake_animation():
	visible = true
	var spawn_tween = get_tree().create_tween()
	spawn_tween.set_ease(Tween.EASE_OUT)
	spawn_tween.set_trans(Tween.TRANS_CUBIC)
	spawn_tween.tween_property(self, "scale", scale, 0.25)
	scale = Vector2.ZERO


func _do_sleep_animation():
	var despawn_tween = get_tree().create_tween()
	despawn_tween.set_ease(Tween.EASE_OUT)
	despawn_tween.set_trans(Tween.TRANS_QUAD)
	despawn_tween.tween_property(self, "scale", Vector2.ZERO, 0.25)
	despawn_tween.tween_callback(func(): visible = false)
	
	await despawn_tween.finished

func _on_day_start():
	super()
	curr_state = activityStates.IDLE
	_do_wake_animation()
