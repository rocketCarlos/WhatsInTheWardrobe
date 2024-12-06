extends AnimatedSprite2D

'''
Card

Node that shows cards
'''

@onready var label = $Label
@onready var button = $TextureButton
@onready var door = $DoorOpening
@onready var failed = $Failed
@onready var passed = $Passed
@onready var angry = $Angry

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play(animation)
	if animation != &"credits":
		door.play(0.27)
		await get_tree().create_timer(4).timeout
		if animation != &"passed" and animation != &"grandma":
			angry.play()
		await get_tree().create_timer(4).timeout
		angry.stop()
		if animation == &"passed":
			passed.play()
		else:
			failed.play()
			
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# label should be shown only in the last frame of the busted_item animation
	if label.text != "" and frame == 2:
		label.show()
	else:
		label.hide()
	
	# button should be visible only in the last frame of any animation except the credits
	if frame == 0 and animation != &"credits":
		button.hide()
	else:
		button.show()


func _on_texture_button_pressed() -> void:
	Globals.main.card_closed()
	queue_free()
