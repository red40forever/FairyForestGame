class_name Mole
extends Entity

var the_stupid_way: GridObjectAttributes = Resources.find("object")["mole_hill"]

func set_new_target(new_target: Vector2i):
	super(new_target)
	main_sprite.play("walk")

func _on_tween_finished():
	super()
	main_sprite.play("idle")

func get_class_name(): return "Mole"

# Mole digs new MoleHill on empty tiles
func interact_with_empty_tile():
	var hill = GameManager.tilemap_manager.create_object_at_coords(the_stupid_way, grid_coordinates)
	interactions_completed += 1
	set_home(hill)
	return_home.emit(self, slot)
