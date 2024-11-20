extends Sprite2D

#region attributes
# Indicates the current sprite displayed. 0 == closed, 1 == open. Setting current_sprite to 0 or 1 
# automatically makes the object show the corresponding sprite
var current_sprite:
	set(which):
		current_sprite = which
		if current_sprite == 0:
			texture = sprite_closed
			$Bright.texture = sprite_closed
			$Area2D/CollisionShape2D.shape = collider_closed
		elif current_sprite == 1:
			texture = sprite_open
			$Bright.texture = sprite_open
			$Area2D/CollisionShape2D.shape = collider_open
		else:
			push_error("Invalid sprite selected in node ", name)

# Represents the sprite displayed when the item is closed and generates its collision shape
var collider_closed
var sprite_closed:
	set(path):
		sprite_closed = load(path)
		var collider = RectangleShape2D.new()
		collider.size = Vector2(sprite_closed.get_width(), sprite_closed.get_height())
		collider_closed = collider
		
		current_sprite = 0

# Represents the sprite displayed when the item is open and generates its collision shape
var collider_open
var sprite_open:
	set(path):
		sprite_open = load(path)
		var collider = RectangleShape2D.new()
		collider.size = Vector2(sprite_open.get_width(), sprite_open.get_height())
		collider_open = collider
		
		current_sprite = 1
		

var mouse_in_collider
#endregion

#region ready and process
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_in_collider = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# toggles between open and closed sprites 
	if Input.is_action_just_pressed("Interact") and mouse_in_collider:
		current_sprite = (current_sprite + 1) % 2
#endregion

#region signal functions
func _on_area_2d_mouse_entered() -> void:
	$Bright.show()
	mouse_in_collider = true


func _on_area_2d_mouse_exited() -> void:
	$Bright.hide()
	mouse_in_collider = false
#endregion
