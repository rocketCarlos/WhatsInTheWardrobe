extends Sprite2D

'''
GenericContainer

Represents a generic container, such as drawers or wardrobes. GenericContainers have two states:
open and closed. GenericContainers, slots and items can be nested inside another GenericContainer. 
When a GenericContainer is open, it shows the nested objects. When it's closed, it hides the nested 
objects and they become inaccessible.  
'''
 #region scene nodes
@onready var highlight = $Highlight
@onready var hitbox = $Hitbox
@onready var hitbox_shape_closed = $Hitbox/ShapeClosed
@onready var hitbox_shape_open = $Hitbox/ShapeOpen

@onready var closing = $closing
@onready var opening = $opening
#endregion

#region attributes
# represents the container's state. false->closed true->open
# when set, the container's sprite is changed
var only_once = true
var open : bool:
	set(value):
		open = value
		if open:
			opening.play()
			texture = sprite_open
			highlight.texture = sprite_open
			# when open, children are visible
			for child in children:
				child.show()
		else:
			if not only_once:
				closing.play()
			else:
				only_once = false
				
			texture = sprite_closed
			highlight.texture = sprite_closed
			# when closed, children are not visible
			for child in children:
				child.hide()

# variables that indicate if the cursor is inside any of the two collision shapes
var mouse_in_open : bool
var mouse_in_closed : bool

# Represents the sprite displayed when the item is closed and generates its collision shape when set
@export var sprite_closed: Texture2D:
	set(asset):
		# the hitbox is a box that fits the item
		sprite_closed = asset
		var collider = RectangleShape2D.new()
		collider.size = Vector2(sprite_closed.get_width(), sprite_closed.get_height())
		# await until all nodes are defined, then set the params
		await ready
		hitbox_shape_closed.shape = collider

# Represents the sprite displayed when the item is open and generates its collision shape when set
@export var sprite_open: Texture2D:
	set(asset):
		# the hitbox is a box that fits the item
		sprite_open = asset
		var collider = RectangleShape2D.new()
		collider.size = Vector2(sprite_open.get_width(), sprite_open.get_height())
		# await until all nodes are defined, then set the params
		await ready
		hitbox_shape_open.shape = collider

# Container's parent when it comes to placement in the room.
# Used for managing interaction and visibility
@export var parent: Node
# Container's children when it comes to placement in the room. 
# I.e., the objects that this container contains
@export var children: Array[Node]
# When true, the object ignores all interactions i.e. hitbox is disabled
var disabled : bool:
	set(value):
		disabled = value
		hitbox_shape_open.set_deferred(&"disabled", disabled)
		hitbox_shape_closed.set_deferred(&"disabled", disabled)
		
# if set, the container will require an item to be opened. This is the name of that item
@export var required_item: String
#endregion

#region ready, process and restart
# called when the game restarts to set up all params again
func restart() -> void:
	open = false
	mouse_in_open = false
	mouse_in_closed = false
	highlight.centered = centered
	highlight.offset = offset
	if centered == false:
		hitbox.position += Vector2(sprite_closed.get_width()/2.0 + offset.x, sprite_closed.get_height()/2.0 + offset.y)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart()
	
	# if this node has a parent, show this node above its parent
	if parent:
		z_index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# toggles between open and closed sprites 
	if Input.is_action_just_pressed("Interact"):
		if (open and mouse_in_open) or (not open and mouse_in_closed):
			if open: # switching from open to closed
				open = false
			else: # switching from closed to open
				if required_item: # container needs a key
					if Globals.item_manager.selected_item and Globals.item_manager.selected_item.name == required_item: # key is selected
						open = true
						# unselect item
						Globals.item_manager.selected_item.highlight.hide()
						Globals.item_manager.selected_item = null
					else: # key is not selected
						Globals.item_manager.container_locked()
				else: # container does not need a key
					open = true
			
			# if switched to close, check if mouse is there to keep the highlight
			# and to enable parent again
			if not open and not mouse_in_closed:
				highlight.hide()
				if parent:
					parent.disabled = false
	
#endregion

#region signal functions
# ShapeClosed-> 0 ShapeOpen-> 1 because they are set in that order in the scene tree

func _on_hitbox_mouse_shape_entered(shape_idx: int) -> void:
	if shape_idx == 0:
		mouse_in_closed = true
	else:
		mouse_in_open = true
	# when the mouse is inside the current satate associated shape, show highlight
	if int(open) == shape_idx:
		highlight.show()
		# when highlight is show, user can interact with the container. Therefore, this container's
		# parent must be disabled
		if parent:
			parent.disabled = true

func _on_hitbox_mouse_shape_exited(shape_idx: int) -> void:
	if shape_idx == 0:
		mouse_in_closed = false
	else:
		mouse_in_open = false
	# when the mouse leaves the current satate associated shape, hide highlight
	if int(open) == shape_idx:
		highlight.hide()
		# when highlight is not shown, user can't interact with the container. Therefore,
		# this container's parent must be enabled UNLESS DISABLED BY CHILDREN
		if parent and not disabled:
			parent.disabled = false
	
#endregion
