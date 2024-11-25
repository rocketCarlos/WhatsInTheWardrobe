extends Node2D

'''
Node that represents a space where objects can be placed. Each GenericItem should be created as a 
child of a Slot, even though a GenericItem can be placed "inside" another slot during the game.
When a GenericItem is initialized, its GenericItem child will have its position updated to match the
slot. Whenever a day ends, the games checks wheter every item in the game has the same position as
its parent and if they are in the same room to determine the game over. 
'''

var has_item
var mouse_in_collider
@export var scene: EventBus.ROOMS # tells in which room the slot is placed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	has_item = false
	mouse_in_collider = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and mouse_in_collider:
		if not has_item:
			EventBus.request_item.emit(self)



func _on_area_2d_mouse_entered() -> void:
	mouse_in_collider = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in_collider = false
