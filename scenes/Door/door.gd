extends Area2D

'''
Door

Node used to travel from room to room
'''

var mouse_in_collider: bool
@export var room_connection: Globals.ROOMS = Globals.ROOMS.NONE
@onready var sound = $Sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_in_collider = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and mouse_in_collider:
		Globals.scene_manager.switch_room(room_connection)
		sound.play(0.3)


func _on_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(Globals.door_cursor)
	mouse_in_collider = true


func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(Globals.default_cursor)
	mouse_in_collider = false
