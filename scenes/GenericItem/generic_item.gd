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
@onready var zoom = $Zoomed
#endregion

#region attributes
var original_scale: Vector2
var mouse_in_collider : bool
var in_inventory : bool:
	set(value):
		in_inventory = value
		if value:
			var desired_height = Globals.item_manager.inventory.sprite.texture.get_height() * Globals.item_manager.inventory.sprite.scale.y
			scale = Vector2(desired_height/texture.get_height(), desired_height/texture.get_height())
			#scale = scale * Vector2(original_scale.x, original_scale.x)
		else:
			global_scale = original_scale
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
	highlight.centered = centered
	highlight.offset = offset
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_scale = global_scale
	restart()
	_init_textures()
	_init_zoom()
	
	# if this node has a parent, show this node above its parent
	if parent:
		z_index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# manage item interactions
	if Input.is_action_just_pressed("Interact") and mouse_in_collider:
		if not in_inventory: # request going to the inventory
			# IF THERE IS A SELECTED ITEM, A NEW ITEM CAN'T GO INTO THE INVENTORY
			if Globals.item_manager.selected_item == null:
				var response = Globals.item_manager.to_inventory(self)
				if response.status == Globals.item_manager.INVENTORY_STATUS.ACCEPTED: # there's room
					#if item had a parent, enable it again
					if parent:
						parent.disabled = false
					in_inventory = true
					reparent(Globals.item_manager)
					global_position = response.position
					inventory_index = response.idx
					if current_slot:
						current_slot.retrieve_item()
						current_slot = null
			else: # if interacting with an item while having a selected item, unselect that item
				Globals.item_manager.selected_item.highlight.hide()
				Globals.item_manager.selected_item = null
				
		else: # already in inventory, manage selections
			if Globals.item_manager.selected_item == self: # item is already selected, unselect
				Globals.item_manager.selected_item = null
				highlight.hide()
			else: # item is not selected, select self
				if Globals.item_manager.selected_item:
					Globals.item_manager.selected_item.highlight.hide()
				Globals.item_manager.selected_item = self
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

# function to initialize the zoomed version of the item
func _init_zoom() -> void:
	zoom.hide()
	zoom.texture = texture 
	zoom.global_position = get_viewport().get_visible_rect().get_center()
	# we want the zoomed version to occupy 1 vertical fifth of the screen
	var desired_height = get_tree().root.size.y / 5.0
	zoom.scale = Vector2(desired_height / texture.get_height(), desired_height / texture.get_height())
	# bypass the parent's scale
	zoom.scale = zoom.scale / scale
	# we want the zoom a little bit transparent
	zoom.modulate = Color(1, 1, 1, 0.75)
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
	
	if in_inventory:
		_init_zoom()
		zoom.show()
		


func _on_hitbox_mouse_exited() -> void:
	mouse_in_collider = false
	# if item is selected, it is always highlighted
	if Globals.item_manager.selected_item != self: 
		highlight.hide()
	
	# enable parent
	if parent:
		parent.disabled = false
		
	if in_inventory:
		zoom.hide()
	
#endregion
