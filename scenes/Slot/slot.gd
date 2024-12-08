extends Node2D

'''
Slot

Represents a piece of space where selected items from the inventory can be placed. Each item has 
an "original slot", which is the slot they are associated with when a room is designed. When a day
ends (i.e. when Mom arrives from work) each item is checked and the player will only pass that day
if all the items are placed in their original slot
'''

#region scene nodes
@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/Shape
@onready var highlight = $Highlight
#endregion

#region attributes
var mouse_in_collider : bool
# reference to the node that this slot contains
var item: Node
# slot's parent when it comes to placement in the room.
# Used for managing interaction and visibility
@export var parent: Node
#endregion


#region ready, process and restart
# called when the game restarts to set up all params again
func restart() -> void:
	mouse_in_collider = false
	item = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and mouse_in_collider:
		# if the slot has no item and it is clicked, request an item (if tere's any selected)
		if not item and Globals.item_manager.selected_item:
			item = Globals.item_manager.selected_item
			Globals.item_manager.request_item(self)
			highlight.texture = null

#endregion

#region item interaction
# called by items when they are picked up
func retrieve_item() -> void:
	item = null

#endregion

#region signal functions
func _on_hitbox_mouse_entered() -> void:
	mouse_in_collider = true
	
	# if the slot has no item, it can accept items
	if not item:
		# if there's a selected item, show a highlight to indicate an action and disable parent
		if Globals.item_manager.selected_item:
			highlight.texture = Globals.item_manager.selected_item.texture
			highlight.rotation = Globals.item_manager.selected_item.rotation
			highlight.global_scale = Globals.item_manager.selected_item.original_scale
			if parent:
				parent.disabled = true
		else:
			highlight.texture = null
		
 
func _on_hitbox_mouse_exited() -> void:
	mouse_in_collider = false
	highlight.texture = null
	
	# if mouse leaving, slot had no item and there was a selected item, enable parent again
	if not item and Globals.item_manager.selected_item and parent:
		parent.disabled = false

#endregion
