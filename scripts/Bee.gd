class_name Bee
extends Entity

func try_interact_with_object(object: GridObject):
	# TODO
	pass
	if object is Beehive:
		self.return_home.emit(self, slot)