extends Node

'''
Inventory

Node that defines the inventory system. 
'''

#region attributes
# inventory's size
const MAX_INVENTORY = 5
# number of items already in the inventory
var stored = 0:
	set(value):
		stored = value
		if value >= MAX_INVENTORY:
			is_full = true
		else:
			is_full = false

var is_full : bool

# reference to the items stored in the inventory
var inventory_items: Array[Node]
#endregion

#region ready, process and restart
# function called when the game is restarted to set up all parameters to their initial values
func restart() -> void:
	stored = 0
	inventory_items = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#endregion

#region signal functions

#endregion
