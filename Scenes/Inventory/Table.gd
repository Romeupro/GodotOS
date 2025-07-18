extends Control
class_name Table

## A table that can receive dropped inventory items.

signal item_placed_on_table(item_data: Dictionary, position: Vector2)

var placed_items: Array[Dictionary] = []

func _ready() -> void:
	# Connect to any existing inventory items
	pass

func can_accept_drop(global_pos: Vector2) -> bool:
	var local_pos = to_local(global_pos)
	var drop_zone = $DropZone
	return drop_zone.get_rect().has_point(local_pos)

func accept_item_drop(item_data: Dictionary, drop_position: Vector2) -> void:
	var local_pos = to_local(drop_position)
	placed_items.append({
		"data": item_data,
		"position": local_pos
	})
	
	item_placed_on_table.emit(item_data, local_pos)
	print("Item placed on table: ", item_data.name, " at position: ", local_pos)