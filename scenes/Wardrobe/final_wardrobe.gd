extends Sprite2D

@onready var highlight = $Highlight

var mouse_on_collider: bool
@export var required: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_on_collider = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and mouse_on_collider:
		if Globals.item_manager.selected_item and Globals.item_manager.selected_item.name == required:
			Globals.main.end_game()
		else:
			Globals.item_manager.container_locked()


func _on_area_2d_mouse_entered() -> void:
	mouse_on_collider = true
	highlight.show()


func _on_area_2d_mouse_exited() -> void:
	mouse_on_collider = false
	highlight.hide()
