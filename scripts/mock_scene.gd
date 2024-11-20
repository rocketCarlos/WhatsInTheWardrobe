extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MumWardrobe.sprite_closed = "res://assets/interactive objects/mom_wardrobe.png"
	$MumWardrobe.sprite_open = "res://assets/interactive objects/mom_wardrobe_opened.png"
	
	$MumWardrobe/SecurityBox.sprite_closed = "res://assets/interactive objects/drawer2_closed.png"
	$MumWardrobe/SecurityBox.sprite_open = "res://assets/interactive objects/drawer2_opened.png"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
