class_name ResourceSlot

var type: int
var count: int = 0:
	set(value):
		count = min(max(value, 0), max_count)
var max_count: int = -1


func _init(new_type: int, new_max_count: int, new_count: int = 0):
	self.type = new_type
	self.count = new_count
	self.max_count = new_max_count
