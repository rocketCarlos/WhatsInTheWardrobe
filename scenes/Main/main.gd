extends Node

'''
Main

Main scene that controlls the game
'''

#region scene nodes
@onready var main_menu = $MainMenu
@onready var animation_player = $AnimationPlayer
#endregion

#region attributes
@export var scene_manager: PackedScene
# a reference to the instantiated scene_manager
var instance_reference: Node
#endregion

#region ready and process
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.main = self
	animation_player.play(&"initial_cutscene")
	Globals.current_day = 0
	Input.set_custom_mouse_cursor(Globals.default_cursor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#endregion

#region state control
# starts the game by instantiating the scene_manager
func play() -> void:
	animation_player.play(&"start_game")
	instance_reference = scene_manager.instantiate()
	add_child(instance_reference)

# checks the result of the ended day and loads the next one
func day_ended(result: Dictionary) -> void:
	print("main says: day has ended ", result)
	# delete the previous scene manager
	instance_reference.queue_free()
	
	if Globals.current_day == 2: # after day 2, grandma comes
		#TODO: show grandma scene
		# reintantiate last day
		instance_reference = scene_manager.instantiate()
		add_child(instance_reference)
		#TODO: transition to rooms
	elif result.dayPassed:
		Globals.current_day += 1
		#TODO: show passed card
		# instantiate next day
		instance_reference = scene_manager.instantiate()
		add_child(instance_reference)
		#TODO: transition to rooms
	else: 
		if result.detectedItem == "container":
			#TODO: show busted bc of container card
			pass
		else:
			#TODO: show busted bc of item card
			pass
			
		# reinstantiate that day
		instance_reference = scene_manager.instantiate()
		add_child(instance_reference)
		#TODO: transition to rooms
#endregion
