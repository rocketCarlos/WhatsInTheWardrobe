extends Sprite2D

'''
MainMenu

Title screen and main menu
'''

#region scene nodes
@onready var play = $Play
@onready var credits = $Credits
@onready var quit = $Quit
@onready var menu_music = $MenuMusic
@onready var click = $Click
#endregion

var playing = false

func _process(delta: float) -> void:
	if not playing and visible:
		if not Globals.main.final_music.playing:
			menu_music.play(3)
		playing = true

func restart() -> void:
	play.disabled = false
	credits.disabled = false
	quit.disabled = false

#region signal functions
func _on_play_button_up() -> void:
	click.play(0.22)
	# when pressed, show transition to the game
	Globals.main.play()
	play.disabled = true
	credits.disabled = true
	quit.disabled = true
	# after the transition is finished, the buttons are enabled again but the main scene hides the menu
	await Globals.main.animation_player.animation_finished
	
	menu_music.stop()
	playing = false
	

func _on_credits_button_up() -> void:
	click.play(0.22)
	Globals.main.show_card(Globals.CARDS.CREDITS)


func _on_quit_button_up() -> void:
	click.play(0.22)
	get_tree().quit()
#endregion
