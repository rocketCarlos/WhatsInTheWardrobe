extends Sprite2D

var main_collider
var main_sprite:
	set(path):
		main_sprite = load(path)
		var collider = RectangleShape2D.new()
		collider.size = Vector2(main_sprite.get_width(), main_sprite.get_height())
		main_collider = collider
		
var second_collider
var second_sprite:
	set(path):
		second_sprite = load(path)
		var collider = RectangleShape2D.new()
		collider.size = Vector2(second_sprite.get_width(), second_sprite.get_height())
		second_collider = collider
		
var current_sprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_sprite = "res://assets/interactive objects/mom_wardrobe.png"
	second_sprite = "res://assets/interactive objects/mom_wardrobe_opened.png"
	current_sprite = 0
	texture = main_sprite
	$Bright.texture = main_sprite
	$Area2D/CollisionShape2D.shape = main_collider

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if current_sprite == 0:
			texture = second_sprite
			$Bright.texture = second_sprite 
			$Area2D/CollisionShape2D.shape = second_collider
			current_sprite = 1
		elif current_sprite == 1:
			texture = main_sprite
			$Bright.texture = main_sprite
			$Area2D/CollisionShape2D.shape = main_collider
			current_sprite = 0


func _on_area_2d_mouse_entered() -> void:
	$Bright.show()


func _on_area_2d_mouse_exited() -> void:
	$Bright.hide()
