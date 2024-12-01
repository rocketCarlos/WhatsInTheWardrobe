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
#endregion

#region attributes
var current_scene
#endregion

func _ready() -> void:
	Globals.scene_manager = self
	current_scene = kids 
	current_scene.show()


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
			
