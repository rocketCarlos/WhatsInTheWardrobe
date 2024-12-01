extends Node

'''
ItemManager

Scene that serves as a global interface for other nodes to communicate with the 
inventory system and as a storage for item nodes while the game is running.

When creating a new room (i.e. kitchen, entrance, etc) items are placed as children of that scene,
however, when they go to the inventory, they are reparented so that they can be separated from their
original rooms.
'''

#region scene nodes
@onready var _inventory = $Inventory
@export var message_service: PackedScene
#endregion

#region globals
# reference to the item that is currently selected
var selected_item: Node = null

var msg_inventory_full = "The inventory is full! Place an item somewhere before picking up another"
var msg_locked = "You'll need a key to open this..."
#endregion

#region inventory interaction
enum INVENTORY_STATUS {
	ACCEPTED,
	REJECTED
}

# function called by items to request being transferred into the inventory
func to_inventory(item: Node) -> Dictionary:
	return _inventory.to_inventory(item)

#endregion

#region messages
# called when the inventory is full to display an error message
func inventory_full() -> void:
	var msg = message_service.instantiate()
	add_child(msg)
	msg.play_animation(msg_inventory_full, 5.5)
	
func container_locked() -> void:
	var msg = message_service.instantiate()
	add_child(msg)
	msg.play_animation(msg_locked, 4)

#endregion

#region slot interaction
# called by slots when they're clicked while an item is selected
# selected item ends up going from the inventory to the slot
func request_item(slot: Node) -> void:
	_inventory.retrieve_item(selected_item.inventory_index)
	selected_item.go_to_slot(slot)
	selected_item = null

#endregion


func _ready() -> void:
	Globals.item_manager = self
