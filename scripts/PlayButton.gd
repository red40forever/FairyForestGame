extends MainMenuButton

@export var main_scene: PackedScene
@export var root_node: Node
@export var fade_overlay: FadeOverlay


func _ready() -> void:
	if GameManager.debug_flags["skip_main_menu"]:
		_load_main_scene.call_deferred() # call_deferred because in _ready


func _on_pressed() -> void:
	fade_overlay.fade_out()
	await fade_overlay.fade_out_complete
	_load_main_scene()


func _load_main_scene():
	var main_scene_node: Node = main_scene.instantiate()
	get_tree().root.add_child(main_scene_node)
	root_node.queue_free()
