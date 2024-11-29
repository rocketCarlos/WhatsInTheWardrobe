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
	# manage item interactions
	if Input.is_action_just_pressed("Interact") and mouse_in_collider:
		if not in_inventory: # request going to the inventory
			var response = ItemManager.to_inventory(self)
			
			if response.status == ItemManager.INVENTORY_STATUS.ACCEPTED: # there's room
				in_inventory = true
				position = response.position
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

#region signal functions
func _on_hitbox_mouse_entered() -> void:
	highlight.show()
	mouse_in_collider = true


func _on_hitbox_mouse_exited() -> void:
	if ItemManager.selected_item != self: # if item is selected, it is always highlighted
		highlight.hide()
	mouse_in_collider = false
		
	
#endregion
