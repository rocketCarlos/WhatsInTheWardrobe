extends Node

'''
SceneManager

Node that manages rooms
'''

#region scene nodes
@onready var corridor = $Rooms/Corridor
@onready var entrance = $Rooms/Entrance
@onready var kids = $Rooms/Kids
@onready var kitchen = $Rooms/Kitchen
@onready var living = $Rooms/Living
@onready var moms = $Rooms/Moms
@onready var day_timer = $DayTimer
@onready var rooms = $Rooms
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
	var items = get_tree().get_nodes_in_group(&"items")
	var containers = get_tree().get_nodes_in_group(&"Containers")
	var passed = true
	
	var item_name = ""
	for item in items: # check if all items are in their original spot
		if item.current_slot != item.original_slot:
			passed = false
			item_name = item.name
			break
	
	for container in containers: # check if all containers are closed
		if container.open:
			passed = false
			item_name = "container"
			break
	
	return { "dayPassed": passed, "detectedItem": item_name }
	
	
	
	
	
	
	
	
	
	
	
