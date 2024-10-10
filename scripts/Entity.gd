class_name Entity
extends GridObject

@export_group("Attributes")
@export var entity_attributes: EntityAttributes

@export_group("Interactions")
@export var carryable_resources: Array[Slot.ResourceType]
@export var max_storage: int = 1
var interactions_completed: int = 0
var idle: bool = true
var slot: Slot

# Movement
var target: Vector2
var home: Node
var tween: Tween = null

signal return_home(entity_reference_to_free: Entity)
#signal deposit_resources(resources_to_deposit: Slot)

func _ready():
	target = self.position
	slot = Slot.new(carryable_resources, max_storage)

func _process(delta: float) -> void:
	if not idle:
		if interactions_completed >= entity_attributes.max_interactions:
			go_towards_home()
		self.grid_coordinates = GameManager.tilemap_manager.ground_layer.local_to_map(self.position)

# TODO how to receive a new target? signal? from where? from player input?
func set_new_target(new_target: Vector2i):
	# TODO sprite faces direction of movement
	idle = false
	# convert tilemap coords into world coords
	target = GameManager.tilemap_manager.ground_layer.map_to_local(new_target)
	
	# Create tween that moves sprite to target
	var direction := target - self.position
	direction = direction.normalized()
	# Remove old tween if it was present,
	# ex. if a new target is set before the old tween finished
	if tween != null:
		tween.queue_free()
	# Create and set up the new tween
	tween = get_tree().create_tween()
	var tween_duration = 10 # TODO determine duration based on speed and distance
	tween.tween_property(self, "global_position", target, tween_duration)
	tween.finished.connect(_on_tween_finished)

func set_home(new_home: Node) -> void:
	home = new_home

func set_attributes(new_attributes: EntityAttributes) -> void:
	entity_attributes = new_attributes

func go_towards_home() -> void:
	target = home.global_position

# When tween is finished, entity has stopped moving.
func _on_tween_finished():
	tween = null
	
	# Determine what type of tile we've stopped at, do stuff accordingly
	var mgr = GameManager.tilemap_manager
	var map_coords = mgr.ground_layer.local_to_map(self.position)
	var objects = mgr.get_objects_at(map_coords)
	# If valid object type, do stuff
	#for object in objects:
		

# Override this function in subclasses to add more behavior 
# without removing what is specified above.
# Don't forget to perform checks for action limit.
func try_interact_with_object(object: GridObject):
	assert(false, "Subclasses must override try_interact_with_object(object: GridObject)")
