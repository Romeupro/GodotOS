extends Control
class_name InventoryManager

## Manages the inventory system including adding items, handling drag and drop,
## and organizing items in the grid layout.

@onready var grid_container: GridContainer = $GridContainer

var inventory_items: Array[InventoryItem] = []

func _ready() -> void:
	# Add some test items to demonstrate the system
	add_test_items()

func add_item(item_data: Dictionary) -> void:
	var inventory_item = preload("res://Scenes/Inventory/InventoryItem.tscn").instantiate()
	inventory_item.set_food_item(item_data)
	inventory_item.item_dropped.connect(_on_item_dropped)
	
	grid_container.add_child(inventory_item)
	inventory_items.append(inventory_item)

func remove_item(item: InventoryItem) -> void:
	if item in inventory_items:
		inventory_items.erase(item)
		item.queue_free()

func _on_item_dropped(item: InventoryItem, drop_position: Vector2) -> void:
	# Check if item was dropped on a table
	var tables = get_tree().get_nodes_in_group("drop_target")
	for table in tables:
		if table.has_method("can_accept_drop") and table.can_accept_drop(drop_position):
			# Item dropped on table
			table.accept_item_drop(item.get_food_item(), drop_position)
			remove_item(item)
			return
	
	# Check if the item was dropped outside the inventory
	var inventory_rect = get_global_rect()
	
	if not inventory_rect.has_point(drop_position):
		print("Item dropped outside inventory at: ", drop_position)
		# Return to original position if no valid drop target
		item.global_position = item.original_position
	else:
		# Reposition within inventory grid
		reposition_item_in_grid(item, drop_position)

func reposition_item_in_grid(item: InventoryItem, drop_position: Vector2) -> void:
	# Convert global position to local grid position
	var local_pos = grid_container.to_local(drop_position)
	
	# Find the closest grid slot
	var grid_size = Vector2(48, 48)  # Size of inventory slots
	var grid_x = int(local_pos.x / grid_size.x)
	var grid_y = int(local_pos.y / grid_size.y)
	
	# Clamp to grid bounds
	grid_x = clamp(grid_x, 0, grid_container.columns - 1)
	grid_y = clamp(grid_y, 0, (inventory_items.size() / grid_container.columns))
	
	# Calculate new index in the grid
	var new_index = grid_y * grid_container.columns + grid_x
	new_index = clamp(new_index, 0, inventory_items.size() - 1)
	
	# Move the item in the grid
	var current_index = inventory_items.find(item)
	if current_index != -1 and new_index != current_index:
		grid_container.move_child(item, new_index)

func add_test_items() -> void:
	# Add some test items to demonstrate the inventory
	var test_items = [
		{"name": "Apple", "texture": load("res://Art/Folder Icons/folder.png"), "description": "A red apple"},
		{"name": "Bread", "texture": load("res://Art/Folder Icons/text_file.png"), "description": "Fresh bread"},
		{"name": "Cheese", "texture": load("res://Art/Folder Icons/image.png"), "description": "Aged cheese"},
		{"name": "Fish", "texture": load("res://Art/Folder Icons/folder.png"), "description": "Fresh fish"},
	]
	
	for item_data in test_items:
		add_item(item_data)