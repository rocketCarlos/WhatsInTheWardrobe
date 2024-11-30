extends Sprite2D

'''
GenericItem

Represents an item in the game. Items can be pickeable to the inventory and can be placed in 
"slots". Items can be required to open some containers. Items must be placed in their original slot
by the end of the day to pass to the next day.
'''

#region scene nodes
@onready var highlight = $Highlight
@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/Shape
#endregion

#region attributes
var mouse_in_collider : bool
var in_inventory : bool
# the index used by the item in the inventory
var inventory_index: int

# when current_slot is set:
# - item's position will match slot's position
# - item is reparented
# - item's parent matches slot's parent
# NOTE: only if new slot is not null
var current_slot : Node:
	set(slot):
		current_slot = slot
		if slot: # if slot is not null
			global_position = slot.global_position
			parent = slot.parent
			reparent(slot)
		else:
			parent = null
		
# the slot where the item is originally placed
@export var original_slot : Node
# item's parent in terms of placement in the room
var parent: Node
#endregion 

#region ready, process and restart
# function called when the game is restarted to set up all parameters to their initial values
func restart() -> void:
	mouse_in_collider = false
	in_inventory = false
	inventory_index = -1
	current_slot = original_slot
	original_slot.item = self
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart()
	_init_textures()
	# if this node has a parent, show this node above its parent
	if parent:
		z_index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# manage item interactions
	if Input.is_action_just_pressed("Interact") and mouse_in_collider:
		if not in_inventory: # request going to the inventory
			# IF THERE IS A SELECTED ITEM, A NEW ITEM CAN'T GO INTO THE INVENTORY
			if ItemManager.selected_item == null:
				var response = ItemManager.to_inventory(self)
				if response.status == ItemManager.INVENTORY_STATUS.ACCEPTED: # there's room
					#if item had a parent, enable it again
					if parent:
						parent.disabled = false
					in_inventory = true
					reparent(ItemManager)
					global_position = response.position
					inventory_index = response.idx
					if current_slot:
						current_slot.retrieve_item()
						current_slot = null
			else: # if interacting with an item while having a selected item, unselect that item
				ItemManager.selected_item.highlight.hide()
				ItemManager.selected_item = null
				
		else: # already in inventory, manage selections
			if ItemManager.selected_item == self: # item is already selected, unselect
				ItemManager.selected_item = null
				highlight.hide()
			else: # item is not selected, select self
				if ItemManager.selected_item:
					ItemManager.selected_item.highlight.hide()
				ItemManager.selected_item = self
				highlight.show()

#endregion

#region utility functions
# function to initialize the hitbox and the highlight
func _init_textures() -> void:
	# the hitbox is a box that fits the item
	var collider = RectangleShape2D.new()
	collider.size = Vector2(texture.get_width(), texture.get_height())
	# await until all nodes are defined, then set the params
	await ready
	hitbox_shape.shape = collider
	highlight.texture = texture

#endregion

#region slot and inventory interactions
# function called when the object is required to go to a slot
func go_to_slot(slot: Node) -> void:
	in_inventory = false
	inventory_index = -1
	current_slot = slot

# called by the inventory when it is rearranged
func update_inventory(pos: Vector2, idx: int) -> void:
	global_position = pos
	inventory_index = idx
	
#endregion

#region signal functions
func _on_hitbox_mouse_entered() -> void:
	highlight.show()
	mouse_in_collider = true
	
	# disable parent if not in inventory
	if not in_inventory and parent:
		parent.disabled = true


func _on_hitbox_mouse_exited() -> void:
	mouse_in_collider = false
	# if item is selected, it is always highlighted
	if ItemManager.selected_item != self: 
		highlight.hide()
	
	# enable parent
	if parent:
		parent.disabled = false
	
#endregion
