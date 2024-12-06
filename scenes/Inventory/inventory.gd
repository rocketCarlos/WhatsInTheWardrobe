extends Node

'''
Inventory

Node that defines the inventory system. 
'''

#region scene nodes
@onready var slot_1 = $Slot1
@onready var slot_2 = $Slot2
@onready var slot_3 = $Slot3
@onready var slot_4 = $Slot4
@onready var slot_5 = $Slot5
@onready var add_item = $AddItem
@onready var substract_item = $RetrieveItem
@onready var sprite = $Sprite2D
#endregion

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
var inventory_positions: Array[Vector2]
#endregion

#region ready, process and restart
# function called when the game is restarted to set up all parameters to their initial values
func restart() -> void:
	stored = 0
	
	for i in range(MAX_INVENTORY):
		inventory_items.push_back(null)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart()
	# add slot positions
	inventory_positions.push_back(slot_1.global_position)
	inventory_positions.push_back(slot_2.global_position)
	inventory_positions.push_back(slot_3.global_position)
	inventory_positions.push_back(slot_4.global_position)
	inventory_positions.push_back(slot_5.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#endregion

#region interaction functions
# function called by items when they want to go to the inventory
# if there is room for the calling item, it is included into the inventory and 
# a signal with the information is given to update the item's attributes
func to_inventory(item: Node) -> Dictionary:
	if not is_full: # there is room for the item
		inventory_items[stored] = item
		var position = inventory_positions[stored]
		stored += 1
		add_item.play()
		return { "status": Globals.item_manager.INVENTORY_STATUS.ACCEPTED, "position": position, "idx": stored-1 }
	else: # there is no room for the item
		Globals.item_manager.inventory_full()
		return { "status": Globals.item_manager.INVENTORY_STATUS.REJECTED, "position": null }

# called by the item manager when an item goes from the inventory to a slot
func retrieve_item(idx: int) -> void:
	inventory_items[idx] = null
	
	# rearrange items
	for i in range(idx+1, stored):
		inventory_items[i].update_inventory(inventory_positions[i-1], i-1)
		inventory_items[i-1] = inventory_items[i]
		
	stored -= 1
	substract_item.play()
	
#endregion
