extends Sprite2D

'''
MainMenu

Title screen and main menu
'''

#region scene nodes
@onready var play = $Play
@onready var credits = $Credits
@onready var quit = $Quit
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



#region signal functions
func _on_play_button_up() -> void:
	# when pressed, show transition to the game
	Globals.main.play()
	play.disabled = true
	credits.disabled = true
	quit.disabled = true
	# after the transition is finished, the buttons are enabled again but the main scene hides the menu
	await Globals.main.animation_player.animation_finished
	play.disabled = true
	credits.disabled = true
	quit.disabled = true

func _on_credits_button_up() -> void:
	Globals.main.show_card(Globals.CARDS.CREDITS)


func _on_quit_button_up() -> void:
	get_tree().quit()
#endregion
