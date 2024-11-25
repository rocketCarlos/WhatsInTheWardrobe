extends Sprite2D


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

#endregion

#region ready and process
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_in_collider = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# toggles between open and closed sprites 
	if Input.is_action_just_pressed("Interact") and mouse_in_collider:
		position = position + Vector2((randf() - 0.5) * 10, (randf() - 0.5) * 10)
#endregion

#region signal functions
func _on_area_2d_mouse_entered() -> void:
	highlight.show()
	mouse_in_collider = true

func _on_area_2d_mouse_exited() -> void:
	highlight.hide()
	mouse_in_collider = false

		
#endregion
