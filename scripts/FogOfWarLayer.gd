class_name FogOfWarLayer
extends TileMapLayer

var fog_in_place: bool = true

signal fog_removed


# Called when the node enters the scene tree for the first time.
func _ready():
	#remove_fog()
	pass


func is_fog_at_tile(coords: Vector2i):
	if !fog_in_place:
		return false
	return get_cell_source_id(coords) != -1


func remove_fog():
	fog_in_place = false
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", position - Vector2(0, 32), 2.0)
	tween.set_parallel()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 0.0), 2.0)
	
	fog_removed.emit()
