extends Node

'''
Autoloaded script that provides access to global variables
'''

# reference to the scene_manager scene
var scene_manager: Node
# reference to the main node
var main: Node
# reference to the item manager
var item_manager: Node
# current day in the game i.e. 21, 22 or 23
var current_day: int
#var day_durations = [360, 360, 180]
var day_durations = [5, 5, 5]

var default_cursor = load("res://assets/buttons/cursor.png")
var door_cursor = load("res://assets/buttons/leave_room.png")

enum ROOMS {
	CORRIDOR,
	ENTRANCE,
	KIDS,
	KITCHEN,
	LIVING,
	MOMS,
	NONE
}
