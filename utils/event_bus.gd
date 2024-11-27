extends Node

enum ROOMS {
	LIVING,
	KITCHEN,
	ENTRANCE,
	CORRIDOR,
	MUMS,
	KIDS,
	ANY
}

var selectedItem = null: 
	set(reference):
		if selectedItem:
			selectedItem.highlight.hide()
		selectedItem = reference

signal to_inventory(reference: Node)
signal request_item(reference: Node)
