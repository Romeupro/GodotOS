extends Control
class_name SimpleShop

## A simple shop system that can add items to the inventory.

signal item_purchased(item_data: Dictionary)

@onready var purchase_button: Button = $VBoxContainer/PurchaseButton
@onready var item_label: Label = $VBoxContainer/ItemLabel

var available_items: Array[Dictionary] = [
	{"name": "Apple", "texture": preload("res://Art/Folder Icons/folder.png"), "description": "A fresh red apple"},
	{"name": "Bread", "texture": preload("res://Art/Folder Icons/text_file.png"), "description": "Warm bread"},
	{"name": "Fish", "texture": preload("res://Art/Folder Icons/image.png"), "description": "Fresh fish"},
	{"name": "Cheese", "texture": preload("res://Art/Folder Icons/folder.png"), "description": "Aged cheese"}
]

var current_item_index: int = 0

func _ready() -> void:
	purchase_button.pressed.connect(_on_purchase_pressed)
	update_display()

func _on_purchase_pressed() -> void:
	var item = available_items[current_item_index]
	item_purchased.emit(item)
	
	# Move to next item
	current_item_index = (current_item_index + 1) % available_items.size()
	update_display()

func update_display() -> void:
	if current_item_index < available_items.size():
		var item = available_items[current_item_index]
		item_label.text = "Buy: " + item.name
		purchase_button.text = "Purchase"
	else:
		item_label.text = "No items available"
		purchase_button.text = "Sold Out"
		purchase_button.disabled = true