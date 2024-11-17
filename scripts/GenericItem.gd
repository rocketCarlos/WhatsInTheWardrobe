extends Sprite2D

var main_sprite = load("res://icon.svg")
var second_sprite = load("res://icon.svg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	texture = second_sprite
	$Bright.texture = second_sprite
	$Bright.show()


func _on_area_2d_mouse_exited() -> void:
	texture = main_sprite
	$Bright.texture = main_sprite
	$Bright.hide()
