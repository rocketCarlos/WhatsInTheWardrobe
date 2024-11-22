extends Sprite2D

#region scene nodes
@onready var highlight = $Highlight
@onready var hitbox = $Hitbox
@onready var hitbox_shape_closed = $Hitbox/ShapeClosed
@onready var hitbox_shape_open = $Hitbox/ShapeOpen

#endregion

#region attributes
# Indicates the current sprite displayed. 0 == closed, 1 == open. Setting current_sprite to 0 or 1 
# automatically makes the object show the corresponding sprite and collision shape
var current_sprite:
	set(which):
		current_sprite = which
		
		if current_sprite == 0:
			texture = sprite_closed
			highlight.texture = sprite_closed
			
			hitbox_shape_closed.set_deferred(&"disabled", false)
			hitbox_shape_open.set_deferred(&"disabled", true)
			
			# tell children to be invisible
			for child in children:
				child.invisible = true
			
		elif current_sprite == 1:
			texture = sprite_open
			highlight.texture = sprite_open
			
			hitbox_shape_closed.set_deferred(&"disabled", true)
			hitbox_shape_open.set_deferred(&"disabled", false)
			
			# tell children to be visible again
			for child in children:
				child.invisible = false
			
		else:
			push_error("Invalid sprite selected in node ", name)

# Represents the sprite displayed when the item is closed and generates its collision shape
@export var sprite_closed: Texture2D:
	set(asset):
		sprite_closed = asset
		var collider = RectangleShape2D.new()
		collider.size = Vector2(sprite_closed.get_width(), sprite_closed.get_height())
		
		await ready
		hitbox_shape_closed.shape = collider
		
# Represents the sprite displayed when the item is open and generates its collision shape
@export var sprite_open: Texture2D:
	set(asset):
		sprite_open = asset
		var collider = RectangleShape2D.new()
		collider.size = Vector2(sprite_open.get_width(), sprite_open.get_height())
		
		await ready
		hitbox_shape_open.shape = collider
				
var mouse_in_collider

@export var parent: Node
@export var children: Array[Node]

# if disabled, the item cannot be selected or interacted with
# used when the mouse is already selecting an son of this object
var disabled:
	set(value):
		if current_sprite == 0:
			hitbox_shape_closed.set_deferred(&"disabled", value)
		else:
			hitbox_shape_open.set_deferred(&"disabled", value)
		
		
# if invisible, the item cannot be selected or intereacted with and it's invisible
# used when this object is inside another object that is closed
var invisible:
	set(value):
		disabled = value
		visible = not value

#endregion

#region ready and process
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_in_collider = false
	current_sprite = 0
	
	disabled = false
	if not parent == null:
		invisible = true
	else:
		invisible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# toggles between open and closed sprites 
	if Input.is_action_just_pressed("Interact") and mouse_in_collider:
		current_sprite = (current_sprite + 1) % 2
#endregion

#region signal functions
func _on_area_2d_mouse_entered() -> void:
	highlight.show()
	mouse_in_collider = true
	
	# tell parent to disable interactions
	if not parent == null:
		parent.disabled = true


func _on_area_2d_mouse_exited() -> void:
	highlight.hide()
	mouse_in_collider = false
	
	# tell parent to enable interactions
	if not parent == null:
		parent.disabled = false
		
#endregion
