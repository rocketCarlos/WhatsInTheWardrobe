extends Node

'''
ItemManager

Autoloaded scene that serves as a global interface for other nodes to communicate with the 
inventory system and as a storage for item nodes while the game is running.

When creating a new room (i.e. kitchen, entrance, etc) items are placed as children of that scene,
however, when they go to the inventory, they are reparented so that they can be separated from their
original rooms.
'''

#region scene nodes
@onready var _inventory = $Inventory
#endregion

#region globals
enum ROOMS {
	LIVING,
	KITCHEN,
	ENTRANCE,
	CORRIDOR,
	MUMS,
	KIDS,
	NONE
}

# reference to the item that is currently selected
var selected_item: Node = null
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

#region slot interaction
# called by slots when they're clicked while an item is selected
# selected item ends up going from the inventory to the slot
func request_item(slot: Node) -> void:
	selected_item.go_to_slot(slot)
	_inventory.retrieve_item(selected_item.inventory_index)
	selected_item = null

#endregion
