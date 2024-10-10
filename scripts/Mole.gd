class_name Mole
extends Entity


func _ready():
	super()
	
	GameManager.player.camera.tile_clicked.connect(_on_tile_clicked)


func _on_tile_clicked(coordinates: Vector2i):
	set_new_target(coordinates)


func set_new_target(new_target: Vector2i):
	super(new_target)
	main_sprite.play("walk")

func _on_tween_finished():
	super()
	main_sprite.play("idle")

func get_class_name(): return "Mole"
