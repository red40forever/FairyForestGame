class_name Entity
extends GridObject

@export_group("Resources")
@export var entity_attributes: EntityAttributes

var target: Vector2
var home: Node
var interactions_completed: int = 0
var idle: bool = true

signal return_home(resources_to_deposit: int, entity_reference_to_free: Node)

func _ready():
	target = self.position
	# TODO debug, remove later
	set_new_target(Vector2i(5,5))

func _process(delta: float) -> void:
	if not idle:
		if interactions_completed >= entity_attributes.max_interactions:
			go_towards_home()
	

func _physics_process(delta: float) -> void:
	if not idle:
		pass

# TODO how to receive a new target? signal? from where? from player input?
func set_new_target(new_target: Vector2i):
	idle = false
	# convert tilemap coords into world coords
	target = GameManager.tilemap_manager.ground_layer.map_to_local(new_target)
	
	# Create tween that moves sprite to target
	var direction := target - self.position
	direction = direction.normalized()
	# TODO sprite faces direction of movement
	var tween = get_tree().create_tween()
	var tween_duration = 10 # TODO
	tween.tween_property(self, "global_position", target, tween_duration)
	# TODO call on_reached_target when tween ends

func set_home(new_home: Node) -> void:
	home = new_home

func go_towards_home() -> void:
	target = home.global_position

# TODO determine what type of target we're at, do stuff accordingly
func on_reached_target():
	pass
