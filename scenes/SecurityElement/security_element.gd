extends AnimatedSprite2D

'''
SecurityElement

represents a slot in the security box
'''

enum TYPE { SYMBOL, NUMBER }

@export var type: TYPE:
	set(value):
		type = value
		if type == TYPE.SYMBOL:
			animation = &"shapes"
		else:
			animation = &"numbers"

func _on_arrow_up_pressed() -> void:
	frame = (frame + 1) % sprite_frames.get_frame_count(animation)


func _on_arrow_down_pressed() -> void:
	frame = (frame + sprite_frames.get_frame_count(animation) - 1) % sprite_frames.get_frame_count(animation)
