extends Sprite2D

@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/Shape
@onready var zoom = $Zoom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# the hitbox is a box that fits the item
	var collider = RectangleShape2D.new()
	collider.size = Vector2(texture.get_width(), texture.get_height())
	hitbox_shape.shape = collider
	
	zoom.hide()

func _on_hitbox_mouse_entered() -> void:
	zoom.texture = texture 
	zoom.global_position = get_viewport().get_visible_rect().get_center()
	var desired_height = get_tree().root.size.y / 1.3
	zoom.global_scale = Vector2(desired_height / texture.get_height(), desired_height / texture.get_height())
	# bypass the parent's scale
	#zoom.scale = zoom.scale / scale
	# we want the zoom a little bit transparent
	zoom.modulate = Color(1, 1, 1, 0.85)
	zoom.show()

func _on_hitbox_mouse_exited() -> void:
	zoom.hide()
