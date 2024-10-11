class_name Entity
extends GridObject

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
var home: HomeTile
var tween: Tween = null

signal return_home(entity_reference_to_free: Entity)
#signal deposit_resources(resources_to_deposit: Slot)

func _ready():
	super()
	
	target = self.position
	
	slot = Slot.new(carryable_resources, max_storage)
	
	if slot_display:
		slot_display.displayed_slot = slot
	else:
		push_warning("Entity '", name, "' does not have a SlotDisplay.")
	
	GameManager.player.selection_changed.connect(_on_selection_changed)

func _process(delta: float) -> void:
	if not idle:
		if interactions_completed >= entity_attributes.max_interactions:
			set_new_target(home.grid_coordinates)
		self.grid_coordinates = GameManager.tilemap_manager.ground_layer.local_to_map(self.position)


func set_new_target(new_target: Vector2i):
	if new_target == Vector2i(target):
		return
	
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
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", target, tween_duration)
	tween.finished.connect(_on_tween_finished)
	
	# Visual flip depending on direction
	if target.x <= position.x:
		main_sprite.flip_h = true
	else:
		main_sprite.flip_h = false

func set_home(new_home: HomeTile) -> void:
	new_home.add_entity(self)

func set_attributes(new_attributes: EntityAttributes) -> void:
	entity_attributes = new_attributes

# When tween is finished, entity has stopped moving.
func _on_tween_finished():
	tween = null
	
	if GameManager.player.selected_object == self:
		GameManager.player.selected_object = null
	
	# Determine what type of tile we've stopped at, do stuff accordingly
	var mgr = GameManager.tilemap_manager
	var map_coords = mgr.ground_layer.local_to_map(self.position)
	var objects = mgr.get_objects_at(map_coords)
	
	if len(objects) == 1:
		interact_with_empty_tile()
		return
	
	# If valid object type, do stuff
	for object in objects:
		if object is InteractableGridObject:
			var inter = try_interact_with_object(object)

# override in child classes
func interact_with_empty_tile():
	pass

func try_interact_with_object(object: InteractableGridObject) -> bool:
	if interactions_completed < entity_attributes.max_interactions:
		var inter = object.request_interaction(slot)
		if inter:
			# See if this interaction was effortless
			var found_match = false
			for type_string in effortless_tiles:
				var obj_string = object.get_class_name()
				if obj_string == type_string:
					found_match = true
			if not found_match:
				interactions_completed += 1
			return true
		elif object is HomeTile or object.get_class_name() == home_tile_name:
			return_home.emit(self, slot)
	return false

func get_class_name(): return "Entity"

func set_selected(new_selected: bool):
	super(new_selected)
	if slot_display:
		slot_display.set_open(new_selected)
	
	var new_selection = GameManager.player.selected_object
	if new_selection is HomeTile:
		set_new_target(new_selection.grid_coordinates)
		GameManager.player.selected_object = null


func _on_selection_changed(old_selection: GridObject, new_selection: GridObject):
	if old_selection == self and new_selection is HomeTile:
		set_new_target(new_selection.grid_coordinates)
		GameManager.player.selected_object = null
