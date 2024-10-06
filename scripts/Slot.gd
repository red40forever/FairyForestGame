class_name Slot

enum ResourceType {
	HONEY,
	POLLEN
}

var accepted_types: Array[ResourceType]
var stored_resources: Dictionary = {}
var total_resource_count: int = 0
var max_count: int = -1

signal resource_added(resource_type: ResourceType, count: int)
signal resource_removed(resource_type: ResourceType, count: int)
signal resource_count_updated(resource_type: ResourceType, count: int)


func _init(new_accepted_types: Array[ResourceType], new_max_count: int = -1):
	self.accepted_types = new_accepted_types
	for type in accepted_types:
		self.stored_resources[type] = 0
	self.max_count = new_max_count


func add_resource(resource_type: ResourceType, count: int):
	assert(count > 0, "Count must be positive.")
	assert(stored_resources.has(resource_type), "Slot cannot take this ResourceType.")
	
	if max_count != -1:
		assert(total_resource_count + count <= max_count, "Count must not cause slot to exceed max count.")
	
	stored_resources[resource_type] += count
	total_resource_count += count
	
	resource_added.emit(resource_added, count)
	resource_count_updated.emit(resource_added, count)


func remove_resource(resource_type: ResourceType, count: int):
	assert(count > 0, "Count must be positive.")
	assert(stored_resources.has(resource_type), "Slot cannot take this ResourceType.")
	
	var resource_count = stored_resources[resource_type]
	assert(resource_count - count >= 0, "Count must not cause slot count to be negative.")
	
	stored_resources[resource_type] -= count
	total_resource_count += count
	
	resource_removed.emit(resource_added, count)
	resource_count_updated.emit(resource_added, count)


func set_resource_count(resource_type: ResourceType, count: int):
	assert(count >= 0, "Count must not be negative.")
	assert(stored_resources.has(resource_type), "Slot cannot take this ResourceType.")
	
	var resource_count = stored_resources[resource_type]
	var total_resource_count_after_set = total_resource_count - resource_count + count
	if max_count != -1:
		assert(total_resource_count_after_set <= max_count, "Count must not cause slot to exceed max count.")
	
	stored_resources[resource_type] = count
	total_resource_count = total_resource_count_after_set
	
	resource_count_updated.emit()


func get_resource_count(resource_type: ResourceType):
	return stored_resources.get(resource_type, 0)
