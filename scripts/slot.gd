extends Node2D

'''
Node that represents a space where objects can be placed. Each GenericItem should be created as a 
child of a Slot, even though a GenericItem can be placed "inside" another slot during the game.
When a GenericItem is initialized, its GenericItem child will have its position updated to match the
slot. Whenever a day ends, the games checks wheter every item in the game has the same position as
its parent and if they are in the same room to determine the game over. 
'''

#region scene nodes
@onready var hitbox_shape = $Area2D/CollisionShape2D
#endregion

#region attributes
var has_item
var mouse_in_collider
@export var scene: EventBus.ROOMS # tells in which room the slot is placed

@export var parent: Node
@export var child: Node

# if disabled, the item cannot be selected or interacted with
# used when the mouse is already selecting an son of this object
var disabled:
	set(value):
		if has_item:
			hitbox_shape.set_deferred(&"disabled", value)
		
# if invisible, the item cannot be selected or intereacted with and it's invisible
# used when this object is inside another object that is closed
var invisible:
	set(value):
		invisible = value
		disabled = value
		visible = not value
		
		if child != null:
			child.invisible = value
#endregion

#region ready and process
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_in_collider = false
	
	disabled = false
	if parent != null:
		invisible = true
		# if the node is a child, make it appear above its parent
		z_index += 1
	else:
		invisible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and mouse_in_collider:
		if not has_item:
			EventBus.request_item.emit(self)

#endregion

#region signal functions
func _on_area_2d_mouse_entered() -> void:
	mouse_in_collider = true
	
	if not has_item:
		if EventBus.selectedItem != null:
			# tell parent to disable interactions
			if not parent == null:
				parent.disabled = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in_collider = false
	
	if not has_item:
		if EventBus.selectedItem != null:
			# tell parent to enable interactions
			if not parent == null:
					parent.disabled = false

#endregion
