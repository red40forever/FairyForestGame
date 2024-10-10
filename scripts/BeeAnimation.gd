extends Sprite2D

@export var bob_height: int = 10


func _ready():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	var peak_pos = position - Vector2(0, bob_height)
	tween.tween_method(set_position_rounded, position, peak_pos, 3.0)
	tween.tween_method(set_position_rounded, peak_pos, position, 3.0)
	tween.set_loops()


func set_position_rounded(pos: Vector2):
	position = round(pos)
