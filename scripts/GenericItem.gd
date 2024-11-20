extends Sprite2D

var main_sprite = load("res://assets/interactive objects/drawer_closed.png")
var second_sprite = load("res://assets/interactive objects/drawer_opened.png")
var current_sprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_sprite = 0
	texture = main_sprite
	$Bright.texture = main_sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if current_sprite == 0:
			texture = second_sprite
			$Bright.texture = second_sprite 
			current_sprite = 1
		elif current_sprite == 1:
			texture = main_sprite
			$Bright.texture = main_sprite
			current_sprite = 0


func _on_area_2d_mouse_entered() -> void:
	$Bright.show()


func _on_area_2d_mouse_exited() -> void:
	$Bright.hide()
