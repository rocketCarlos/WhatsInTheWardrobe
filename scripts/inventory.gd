extends Sprite2D

'''
When a GenericItem is clicked from a scene, it requests to be in the inventory via the EventBus
to_inventory singal. When a GenericItem is selected and is meant to be placed in a slot, the 
request_item function is called to change its position, set its attributes and update the inventory
'''

const MAX_INVENTORY = 5
var in_inventory: 
	set(value):
		in_inventory = value
		if value >= MAX_INVENTORY:
			full = true
		else:
			full = false
		
var full

@export var item_positions: Array[Vector2]
var inventory_items: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.to_inventory.connect(_on_to_inventory)
	EventBus.request_item.connect(_on_request_item)

	in_inventory = 0
	for i in range(MAX_INVENTORY):
		inventory_items.push_back(null)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_next_available_position():
	in_inventory += 1
		
	return item_positions[in_inventory-1]

func _on_to_inventory(reference: Node):
	if not full:
		reference.global_position = get_next_available_position()
		reference.in_inventory = true
		reference.slot.has_item = false
		reference.slot = null
		reference.inventory_index = in_inventory-1
		inventory_items[in_inventory-1] = reference
		print("Added to inventory")
	
func _on_request_item(reference: Node):
	if EventBus.selectedItem != null:
		# retrieve the selected item to the referenced slot
		var item = EventBus.selectedItem
		EventBus.selectedItem = null
		in_inventory -= 1
		
		item.in_inventory = false
		item.inventory_index = null
		item.global_position = reference.global_position
		item.slot = reference
		
		reference.has_item = true
	
	# rearange items
	
	
