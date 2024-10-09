class_name Slot

enum ResourceType {
	HONEY,
	POLLEN
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


func get_resource_count(resource_type: ResourceType):
	return stored_resources.get(resource_type, 0)
