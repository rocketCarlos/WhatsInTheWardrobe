extends Label

'''
MessageService

Used by other nodes to display messages in screen
'''

func play_animation(txt: String, duration: float):
	$Timer.start(duration)
	text = txt
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -40), duration)
	tween.parallel()
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 0), duration)
	show()
	
func _ready():
	pass

func _on_timer_timeout() -> void:
	queue_free()
