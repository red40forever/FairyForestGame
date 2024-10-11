class_name Slot

enum ResourceType {
	HONEY,
	POLLEN,
	MUSHROOM,
	SPORE,
	NULL
}

var accepted_types: Array[ResourceType]
var stored_resources: Dictionary = {}
var total_resource_count: int = 0
var max_count: int = -1

signal resource_count_updated(resource_type: ResourceType, old_count: int, new_count: int)


func _init(p_accepted_types: Array[ResourceType], p_max_count: int = -1):
	self.accepted_types = p_accepted_types
	for type in accepted_types:
		self.stored_resources[type] = 0
	self.max_count = p_max_count


func add_resource(resource_type: ResourceType, count: int):
	assert(count > 0, "Count must be positive.")
	assert(stored_resources.has(resource_type), "Slot cannot take this ResourceType.")
	
	var new_count = stored_resources[resource_type] + count
	set_resource_count(resource_type, new_count)


func remove_resource(resource_type: ResourceType, count: int):
	assert(count > 0, "Count must be positive.")
	assert(stored_resources.has(resource_type), "Slot cannot take this ResourceType.")
	
	var new_count = stored_resources[resource_type] - count
	assert(new_count >= 0, "Count must not cause slot count to be negative.")
	
	set_resource_count(resource_type, new_count)


func set_resource_count(resource_type: ResourceType, count: int):
	assert(count >= 0, "Count must not be negative.")
	assert(stored_resources.has(resource_type), "Slot cannot take this ResourceType.")
	
	var resource_count = stored_resources[resource_type]
	var total_resource_count_after_set = total_resource_count - resource_count + count
	if max_count != -1:
		assert(total_resource_count_after_set <= max_count, "Count must not cause slot to exceed max count.")
	
	var old_count = stored_resources[resource_type]
	stored_resources[resource_type] = count
	total_resource_count = total_resource_count_after_set
	
	resource_count_updated.emit(resource_type, old_count, count)

# Function attempts to add as many resources from count as it can,
# and returns any amount that was unable to be added if it overflows,
# instead of throwing an error.
func add_resource_overflow_safe(resource_type: ResourceType, count: int) -> int:
	assert(count >= 0, "Count must be nonnegative.")
	assert(stored_resources.has(resource_type), "Slot cannot take this ResourceType.")
	
	var overflow = max(0, (total_resource_count + count) - max_count)
	var to_add = 0
	if overflow > 0:
		to_add = max_count - total_resource_count
	else:
		to_add = count
	
	if to_add == 0:
		return 0
	else:
		add_resource(resource_type, to_add)
	
	return overflow

func get_resource_count(resource_type: ResourceType):
	return stored_resources.get(resource_type, 0)

func is_empty() -> bool:
	return total_resource_count == 0
