extends Node

'''
SceneManager

Node that manages rooms
'''

#region scene nodes
@onready var corridor = $Corridor
@onready var entrance = $Entrance
@onready var kids = $Kids
@onready var kitchen = $Kitchen
@onready var living = $Living
@onready var moms = $Moms
@onready var day_timer = $DayTimer
#endregion

#region attributes
var current_scene: Node
#endregion

func _ready() -> void:
	Globals.scene_manager = self
	current_scene = kids 
	current_scene.show()
	day_timer.start(Globals.day_durations[Globals.current_day])

# called by doors to switch from room to room
func switch_room(room: Globals.ROOMS) -> void:
	current_scene.hide()
	match room:
		Globals.ROOMS.CORRIDOR:
			corridor.show()
			current_scene = corridor
		Globals.ROOMS.ENTRANCE:
			entrance.show()
			current_scene = entrance
		Globals.ROOMS.KIDS:
			kids.show()
			current_scene = kids
		Globals.ROOMS.KITCHEN:
			kitchen.show()
			current_scene = kitchen
		Globals.ROOMS.LIVING:
			living.show()
			current_scene = living
		Globals.ROOMS.MOMS:
			moms.show()
			current_scene = moms
		Globals.ROOMS.NONE:
			push_error("Door has no defined connection room!")
			current_scene.show()
			

# when the day ends, checks whether the player lost or won that day
# and inform the main controller
func _on_day_timer_timeout() -> void:
	Globals.main.day_ended(check_ending())


func check_ending() -> Dictionary:
	return { "dayPassed": true, "detectedItem": "" }
	
	
	
	
	
	
	
	
	
	
	
