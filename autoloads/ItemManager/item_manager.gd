extends Node

'''
ItemManager

Autoloaded scene that serves as a global interface for other nodes to communicate with the 
inventory system
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
