extends Node2D

@export var animation_speed: float = 0.1

@export var placement_indicator: PlacementIndicator

var end_position: Vector2
var is_open: bool = false


func _ready():
	visible = false
	placement_indicator.grid_position_changed.connect(_animate_position)


func _set_is_open(new_is_open: bool):
	is_open = new_is_open
	# TODO: Nicer open/close animation for move arrow
	if is_open:
		visible = true
	else:
		visible = false


func _animate_position(grid_position: Vector2i):
	var new_end_position = GameManager.tilemap_manager.map_to_global(grid_position)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_method(update_end_position, end_position, new_end_position, animation_speed)


func update_end_position(new_end_position: Vector2):
	end_position = new_end_position
	
	var global_end_pos = get_parent().to_global(new_end_position)
	var arrow_vector = (global_end_pos - global_position) / scale
	var arrow_magnitude = arrow_vector.length()
	var head_width = %ArrowHead.texture.get_size().x * %ArrowHead.scale.x
	var tail_length = max(arrow_magnitude - head_width * 0.5, 1)
	%ArrowTail.texture.width = tail_length
	%ArrowTail.position = Vector2(tail_length * 0.5, 0)
	%ArrowHead.position = Vector2(arrow_magnitude - 1, 0)
	
	look_at(end_position)
