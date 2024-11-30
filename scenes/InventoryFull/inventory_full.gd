extends Label

func play_animation():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -40), 7)
	tween.parallel()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 7)
	show()
	
func _ready():
	print("i exist")
	play_animation()

func _on_timer_timeout() -> void:
	queue_free()
