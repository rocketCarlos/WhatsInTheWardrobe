extends Sprite2D

'''
SecurityPanel

Represents the close up of the security box. Interface for code combination inputs
'''

#region scene nodes
@onready var shapes_1 = $SecurityElement1
@onready var shapes_2 = $SecurityElement2
@onready var shapes_3 = $SecurityElement3
@onready var shapes_4 = $SecurityElement4
@onready var numbers_1 = $SecurityElement5
@onready var numbers_2 = $SecurityElement6
@onready var numbers_3 = $SecurityElement7
@onready var numbers_4 = $SecurityElement8
#endregion

#region attributes
var current_numbers
var current_shapes

@export var combination_numbers: String
@export var combination_shapes: String
#endregion

#region ready and process
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_numbers = str(numbers_1.frame) + str(numbers_2.frame) + str(numbers_3.frame) + str(numbers_4.frame)
	current_shapes = str(shapes_1.frame) + str(shapes_2.frame) + str(shapes_3.frame) + str(shapes_4.frame)
	if combination_numbers == current_numbers and combination_shapes == current_shapes: # user got the combiantion
		Globals.main.security_open()
		queue_free()
#endregion

#region signal functions
func _on_exit_pressed() -> void:
	Globals.main.security_cancel()
	queue_free()
#endregion
