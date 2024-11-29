extends Sprite2D

'''
When a GenericItem is clicked, it requests to be placed in the inventory via the EventBus. If there
is room for it, its position is changed and it is marked as "in_inventory". While in the inventory, 
the GenericItem may be selected by clicking on it. A selected GenericItem may be placed in a slot 
by clicking in it, which will trigger the request_object signal from the EventBus. After the call, 
the object will no longer be in the inventory and will be placed in the slot. The inventory will be 
updated to rearange the GenericItems stored in it.

When setting up a scene, the GenericItem should have its original_slot attribute set
'''

#region scene nodes
@onready var highlight = $Highlight
@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/Shape

#endregion

#region attributes
# item's sprite
@export var sprite: Texture2D:
	set(asset):
		sprite = asset
		var collider = RectangleShape2D.new()
		collider.size = Vector2(sprite.get_width(), sprite.get_height())
		
		await ready
		hitbox_shape.shape = collider
		highlight.texture = asset
		texture = asset

var mouse_in_collider
var in_inventory:
	set(value):
		in_inventory = value
		# if set to true, enable parent's interaction again
		if value:
			# tell parent to enable interactions
			if parent != null:
				if parent.disabled == true:
					parent.disabled = false
				
var inventory_index
var slot: # the slot were the item is placed, if any
	set(node):
		slot = node
		if node != null:
			node.has_item = true
			global_position = node.global_position
			scene = node.scene
			parent = node.parent
			
		else:
			parent = null

@export var original_slot: Node: # the slot where the item is originally placed 
	set(node):
		original_slot = node
		slot = node
		
@export var scene: EventBus.ROOMS # tells in which room the item is placed

var parent: Node

# if disabled, the item cannot be selected or interacted with
# used when the mouse is already selecting an son of this object
var disabled:
	set(value):
		if not in_inventory:
			if hitbox_shape:
				hitbox_shape.set_deferred(&"disabled", value)
		
# if invisible, the item cannot be selected or intereacted with and it's invisible
# used when this object is inside another object that is closed
var invisible:
	set(value):
		if not in_inventory:
			invisible = value
			disabled = value
			visible = not value
#endregion

#region ready and process
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_in_collider = false
	in_inventory = false
	
	disabled = false
	 
	if parent != null:
		invisible = true
		# if the node is a child, make it appear above its parent
		z_index += 1
	else:
		invisible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# toggles between open and closed sprites 
	if Input.is_action_just_pressed("Interact") and mouse_in_collider:
		if in_inventory:
			print("im selected ", self)
			EventBus.selectedItem = self
			highlight.show()
			
		else:
			EventBus.to_inventory.emit(self)
#endregion

#region signal functions
func _on_area_2d_mouse_entered() -> void:
	highlight.show()
	mouse_in_collider = true
	
	if not in_inventory:
		# tell parent to disable interactions
		if not parent == null:
			parent.disabled = true

func _on_area_2d_mouse_exited() -> void:
	if EventBus.selectedItem != self:
		highlight.hide()
	
	mouse_in_collider = false
	
	# tell parent to enable interactions
	if not parent == null:
			parent.disabled = false
		
		


#endregion
