extends Control
class_name FoodItem

## Base food item that can be used in the shop and inventory system.

@export var item_name: String = "Food Item"
@export var item_texture: Texture2D
@export var item_description: String = "A delicious food item"

func _ready() -> void:
	if item_texture:
		%ItemImage.texture = item_texture
	%ItemLabel.text = item_name

func set_item_data(name: String, texture: Texture2D, description: String = "") -> void:
	item_name = name
	item_texture = texture
	item_description = description
	
	if %ItemImage:
		%ItemImage.texture = item_texture
	if %ItemLabel:
		%ItemLabel.text = item_name

func get_item_data() -> Dictionary:
	return {
		"name": item_name,
		"texture": item_texture,
		"description": item_description
	}