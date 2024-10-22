extends Sprite2D

@export_group("Attributes")
@export var bob_height: int = 4
@export var particle_time_fast = 2.5
@export var particle_time_slow = 5

@export_group("References")
@export var parentEntity: Bee
@export var particles: Node2D

var tween: Tween


func _ready():
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	var peak_pos = position - Vector2(0, bob_height)
	tween.tween_method(set_position_rounded, position, peak_pos, 3.0)
	tween.tween_method(set_position_rounded, peak_pos, position, 3.0)
	tween.set_loops()

func _process(_delta: float) -> void:
	particles.scale.x = -1 if parentEntity.flipped else 1

func _exit_tree():
	tween.kill()


func set_position_rounded(pos: Vector2):
	position = round(pos)
