extends Control

signal page_requested(page_name: String)

var current_text = ""
@onready var inventory_grid = $"Sections/Centre/TabContainer/Sell Item/sell_item/inventory/ScrollContainer/GridContainer"
@onready var item_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/ItemTexture"
@onready var selling_display = $Sections/Centre/TabContainer/sell_list/ScrollContainer/GridContainer

@onready var name_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/Name"
@onready var type_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/Type"
@onready var condition_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/Condition"
@onready var color_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/Color"
@onready var brand_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/Brand"
@onready var price_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/Price"
@onready var exeption_message = $"Sections/Centre/TabContainer/Sell Item/sell_item/display_error"

func _ready() -> void:
	_build_page()

func clear_contents() -> void:
	name_display.clear()
	type_display.clear()
	brand_display.clear()
	condition_display.select(-1)
	color_display.clear()
	price_display.clear()
	for child in item_display.get_children():
		child.queue_free()
	exeption_message.text = ""
	current_text = ""
	
func _build_page() -> void:
	for child in inventory_grid.get_children():
		child.queue_free()
	for child in item_display.get_children():
		child.queue_free()

	Inventory.current_ui_type = "selling"
	for i in range(Inventory.player_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		storage_ui.page_requested.connect(_on_item_page_requested)
		inventory_grid.add_child(storage_ui)
	
	Inventory.current_ui_type = "display"
	for i in range(Inventory.display_item.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		storage_ui.page_requested.connect(_on_item_page_requested)
		item_display.add_child(storage_ui)
	
	Inventory.current_ui_type = "display_selling"
	for i in range(Inventory.actual_selling.size()):
		var packed = preload("res://scenes/selling_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.item_index = i
		selling_display.add_child(storage_ui)
		
	
func _on_item_page_requested(page_name: String) -> void:
	_build_page()
	page_requested.emit(page_name)



func _on_sell_button_pressed() -> void:
	# mmmmm yes this is some clean input sanitation
	var price_written:float = 0
	if price_display.text.is_valid_float():
		price_written = snapped(price_display.text.to_float(),0.01)
	if name_display.text == "":
		exeption_message.text = "Need a name!"
	elif not price_display.text.is_valid_float():
		exeption_message.text = "Price is not valid (do not include $)."
	elif price_written < 1:
		exeption_message.text = "Price must be at least $1."
	elif price_written >= 10000:
		exeption_message.text = "Price must be under $10,000."
	elif condition_display.selected == -1:
		exeption_message.text = "Please select a condition."
	elif Inventory.display_item.size() == 0:
		exeption_message.text = "Please upload a picture."
	else:
		if current_text == "":
			current_text = condition_display.get_item_text(condition_display.selected)
			
		Inventory.transfer_item(Inventory.display_item,
		Inventory.actual_selling, 0)
		var display_dict: Dictionary = {
			"name": name_display.text,
			"type": type_display.text,
			"condition": current_text,
			"color": color_display.text,
			"price": price_written,
			"brand": brand_display.text,
		}
		Inventory.player_selling.append(display_dict)
		clear_contents()
		
		Inventory.current_ui_type = "display_selling"
		var packed = preload("res://scenes/selling_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.item_index = Inventory.player_selling.size() - 1
		selling_display.add_child(storage_ui)
		


func _on_condition_item_selected(index: int) -> void:
	current_text = condition_display.get_item_text(index)
