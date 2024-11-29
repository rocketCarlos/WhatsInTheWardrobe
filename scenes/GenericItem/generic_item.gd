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
var current_slot : Node
var original_slot : Node

#endregion 

#region ready, process and restart
# function called when the game is restarted to set up all parameters to their initial values
func restart() -> void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_textures()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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

#region signal functions
func _on_hitbox_mouse_entered() -> void:
	highlight.show()
	mouse_in_collider = true


func _on_hitbox_mouse_exited() -> void:
	highlight.hide()
	mouse_in_collider = false
		
	
#endregion
