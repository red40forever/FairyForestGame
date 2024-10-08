class_name Entity
extends GridObject

@export_group("Attributes")
@export var entity_attributes: EntityAttributes

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
var home: Node
var tween: Tween = null

signal return_home(entity_reference_to_free: Entity)
#signal deposit_resources(resources_to_deposit: Slot)

func _ready():
	super()
	
	target = self.position
	
	slot = Slot.new(carryable_resources, max_storage)
	
	if slot_display:
		slot_display.displayed_slot = slot
		print(slot_display.name, ": ", slot_display.displayed_slot)
	else:
		push_warning("Entity '", name, "' does not have a SlotDisplay.")

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
		tween.kill()
		
	# Create and set up the new tween
	var distance = (target - position).length()
	tween = get_tree().create_tween()
	var tween_duration = distance / entity_attributes.speed
	tween.tween_property(self, "position", target, tween_duration)
	tween.finished.connect(_on_tween_finished)
	
	# Visual flip depending on direction
	if new_target.x <= grid_coordinates.x:
		main_sprite.flip_h = true
	else:
		main_sprite.flip_h = false

func set_home(new_home: Node) -> void:
	home = new_home

func set_attributes(new_attributes: EntityAttributes) -> void:
	entity_attributes = new_attributes

func go_towards_home() -> void:
	target = home.position

# When tween is finished, entity has stopped moving.
func _on_tween_finished():
	tween = null
	
	if GameManager.player.selected_object == self:
		GameManager.player.selected_object = null
	
	# Determine what type of tile we've stopped at, do stuff accordingly
	var mgr = GameManager.tilemap_manager
	var map_coords = mgr.ground_layer.local_to_map(self.position)
	var objects = mgr.get_objects_at(map_coords)
	# If valid object type, do stuff
	for object in objects:
		if object is InteractableGridObject:
			var inter = try_interact_with_object(object)
			if inter == true:
				break

func try_interact_with_object(object: InteractableGridObject) -> bool:
	if interactions_completed < entity_attributes.max_interactions:
		var inter = object.request_interaction(slot)
		if inter:
			var found_match = false
			for type_string in effortless_tiles:
				var obj_string = object.get_class_name()
				if obj_string == type_string:
					found_match = true
			if not found_match:
				interactions_completed += 1
			return true
	return false

func get_class_name(): return "Entity"

func set_selected(new_selected: bool):
	super(new_selected)
	if slot_display:
		slot_display.set_open(new_selected)
