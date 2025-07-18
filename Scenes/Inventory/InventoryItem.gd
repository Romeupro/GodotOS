extends Control
class_name InventoryItem

## Inventory item component that supports drag and drop functionality.
## Only displays the image from a FoodItem, hiding other UI elements for a clean inventory look.

signal item_dropped(item: InventoryItem, drop_position: Vector2)

var food_item_data: Dictionary = {}
var is_dragging: bool = false
var drag_offset: Vector2
var original_position: Vector2
var drag_preview: Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			start_drag()
		elif is_dragging:
			end_drag()

func _input(event: InputEvent) -> void:
	if is_dragging and event is InputEventMouseMotion:
		update_drag_position()

func start_drag() -> void:
	if food_item_data.is_empty():
		return
		
	is_dragging = true
	original_position = global_position
	drag_offset = get_global_mouse_position() - global_position
	
	# Create drag preview
	%DragPreview.visible = true
	%DragPreview.size = size
	if food_item_data.has("texture") and food_item_data.texture:
		%DragPreview.get_node("PreviewImage").texture = food_item_data.texture
	
	# Make original item semi-transparent
	modulate.a = 0.5
	
	# Move to front for proper layering
	get_parent().move_child(self, get_parent().get_child_count() - 1)

func update_drag_position() -> void:
	if not is_dragging:
		return
		
	var mouse_pos = get_global_mouse_position()
	global_position = mouse_pos - drag_offset

func end_drag() -> void:
	if not is_dragging:
		return
		
	is_dragging = false
	%DragPreview.visible = false
	modulate.a = 1.0
	
	# Check if we're dropping on a valid target
	var drop_position = get_global_mouse_position()
	item_dropped.emit(self, drop_position)
	
	# For now, return to original position if no valid drop target
	# This will be enhanced when table placement is implemented
	global_position = original_position

func set_food_item(item_data: Dictionary) -> void:
	food_item_data = item_data
	
	if item_data.has("texture") and item_data.texture:
		%ItemImage.texture = item_data.texture
		%DragPreview.get_node("PreviewImage").texture = item_data.texture

func get_food_item() -> Dictionary:
	return food_item_data

func _on_mouse_entered() -> void:
	show_hover_highlight()

func _on_mouse_exited() -> void:
	if not is_dragging:
		hide_hover_highlight()

func show_hover_highlight() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($HoverHighlight, "self_modulate:a", 1, 0.15)

func hide_hover_highlight() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($HoverHighlight, "self_modulate:a", 0, 0.15)