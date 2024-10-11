extends TextureRect


func _ready():
	Dialogic.text_signal.connect(win)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func win(txt):
	print(txt)
	if txt != "win":
		return
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 1.0)
	tween.tween_callback(func(): GameManager.paused = true)
