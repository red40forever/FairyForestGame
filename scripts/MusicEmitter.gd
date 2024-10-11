class_name MusicEmitter
extends FmodEventEmitter2D
	
func set_param(param_name: String, value: Variant) -> void:
	self["event_parameter/%s/value" % param_name] = value
