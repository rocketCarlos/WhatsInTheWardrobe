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
var scene_manager_reference: Node

@export var card: PackedScene
# a reference to the instantiated card
var card_reference: Node

# reference to the security box
var box_reference: Node
@export var security_panel: PackedScene
var panel_reference: Node

# the name of the item that was off its position
var busted_item: String
#endregion

#region ready and process
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.main = self
	if not Globals.debug:
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
	scene_manager_reference = scene_manager.instantiate()
	add_child(scene_manager_reference)

# checks the result of the ended day and loads the next one
func day_ended(result: Dictionary) -> void:
	print("main says: day has ended ", result)
	# delete the previous scene manager
	scene_manager_reference.queue_free()
	# manage the next day
	if Globals.current_day == 2: # after day 2, grandma comes
		show_card(Globals.CARDS.GRANDMA)
		await card_reference.tree_exiting
		# reintantiate last day
		scene_manager_reference = scene_manager.instantiate()
		call_deferred(&"add_child", scene_manager_reference)
		#TODO: transition to rooms
	elif result.dayPassed:
		Globals.current_day += 1
		show_card(Globals.CARDS.PASSED)
		await card_reference.tree_exiting
		# instantiate next day
		scene_manager_reference = scene_manager.instantiate()
		call_deferred(&"add_child", scene_manager_reference)
		#TODO: transition to rooms
	else: # day not passed
		if result.detectedItem == "container": # a container was left open
			show_card(Globals.CARDS.BUSTED_CONTAINER)
		else: # an item was moved from its original position
			busted_item = result.detectedItem
			show_card(Globals.CARDS.BUSTED_ITEM)
			
		await card_reference.tree_exiting
		# reinstantiate that day
		scene_manager_reference = scene_manager.instantiate()
		call_deferred(&"add_child", scene_manager_reference)
		#TODO: transition to rooms
		
	if panel_reference:
		panel_reference.queue_free()
		panel_reference = null
#endregion

#region cards
# called when showing a card
func show_card(card_type: Globals.CARDS) -> void:
	card_reference = card.instantiate()
	add_child(card_reference)
	
	match card_type:
		Globals.CARDS.CREDITS:
			card_reference.animation = &"credits"
		Globals.CARDS.BUSTED_CONTAINER:
			card_reference.animation = &"busted_container"
		Globals.CARDS.BUSTED_ITEM:
			card_reference.animation = &"busted_item"
			card_reference.label.text = busted_item
		Globals.CARDS.BUSTED_ROOM:
			card_reference.animation = &"busted_bedroom"
		Globals.CARDS.PASSED:
			card_reference.animation = &"passed"
		Globals.CARDS.GRANDMA:
			card_reference.animation = &"grandma"
		_:
			push_error("INVALID CARD TYPE")

# called when closing a card
func card_closed() -> void:
	card_reference.queue_free()
#endregion

#region security_box
# called when user zooms into the security box
func show_security_box(box: Node) -> void:
	box_reference = box
	scene_manager_reference.rooms.hide()
	panel_reference = security_panel.instantiate()
	call_deferred(&"add_child", panel_reference)
	
# called when the security code is correct
func security_open() -> void:
	box_reference.open = true
	scene_manager_reference.rooms.show()

# called when the user leaves the close up look of the security box
func security_cancel() -> void:
	scene_manager_reference.rooms.show()
#endregion
