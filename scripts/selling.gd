extends Control

signal page_requested(page_name: String)

var current_text = ""
@onready var inventory_grid = $"Sections/Centre/TabContainer/Sell Item/sell_item/ScrollContainer/Sections/1/inventory/ScrollContainer/GridContainer"
@onready var item_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/ScrollContainer/Sections/1/Control/ItemTexture"
@onready var selling_display = $Sections/Centre/TabContainer/sell_list/ScrollContainer/GridContainer
@onready var name_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/ScrollContainer/Sections/2/VBoxContainer/HBoxContainer/Name"
@onready var type_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/ScrollContainer/Sections/3/HBoxContainer/Type"
@onready var condition_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/ScrollContainer/Sections/3/HBoxContainer3/Condition"
@onready var color_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/ScrollContainer/Sections/3/HBoxContainer4/Color"
@onready var brand_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/ScrollContainer/Sections/3/HBoxContainer2/Brand"
@onready var price_display = $"Sections/Centre/TabContainer/Sell Item/sell_item/ScrollContainer/Sections/4/HBoxContainer/Price"
@onready var exeption_message = $"Sections/Centre/TabContainer/Sell Item/sell_item/ScrollContainer/Sections/display_error"
@onready var item_count = $Sections/Centre/TabContainer/sell_list/Label
@onready var sold_display = $Sections/Centre/TabContainer/sold_list/ScrollContainer/GridContainer
@onready var description = $"Sections/Centre/TabContainer/Sell Item/sell_item/ScrollContainer/Sections/2/VBoxContainer/decription"

var template = "Items: {items}/{storage}"
	
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
	for child in sold_display.get_children():
		child.queue_free()
	exeption_message.text = ""
	current_text = ""
	
func _build_page() -> void:
	for child in inventory_grid.get_children():
		child.queue_free()
	for child in item_display.get_children():
		child.queue_free()
	for child in sold_display.get_children():
		child.queue_free()
	for child in selling_display.get_children():
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
	
	Inventory.current_ui_type = "display_sold"
	for i in range(Inventory.actual_sold.size()):
		var packed = preload("res://scenes/sold_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.item_index = i
		sold_display.add_child(storage_ui)
	
	
func _on_item_page_requested(page_name: String) -> void:
	_build_page()
	load_uploaded_item_info()
	page_requested.emit(page_name)
	Inventory.item_sold.connect(_build_page)


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
	elif Inventory.player_selling.size() >= 10:
		exeption_message.text = "Cannot sell any more items."
	else:
		if current_text == "":
			current_text = condition_display.get_item_text(condition_display.selected)
		
		
		var listing = Inventory.display_item[0].duplicate()
		Inventory.sell_id += 1
		listing["listing_sell_id"] = Inventory.sell_id
		var list_thing = [] #omg this is so dumb
		list_thing.append(listing)
		Inventory.transfer_item(list_thing,
		Inventory.actual_selling, 0)
		
		var color = color_display.text
		var color1 = ""
		var color2 = ""
		var colors = color.split(" ") 
		if colors.size() >= 3:
			for col in colors:
				if col == "+" or col == "&" or col.to_lower() == "and":
					colors.erase(col)
		if colors.size() == 2:
			color1 = colors[0]
			color2 = colors[1]
		elif colors.size() == 1:
			color1 = colors[0]
			color2 = "none"
			
				
		var display_dict: Dictionary = {
			"name": name_display.text,
			"type": type_display.text,
			"condition": current_text,
			"color": color_display.text,
			"color1": color1,
			"color2": color2,
			"price": price_written,
			"brand": brand_display.text,
			"description": description.text
		}
		Inventory.player_selling.append(display_dict)
		clear_contents()
		
		Inventory.current_ui_type = "display_selling"
		var packed = preload("res://scenes/selling_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.item_index = Inventory.player_selling.size() - 1
		selling_display.add_child(storage_ui)
		print(Inventory.actual_selling[-1])
		Inventory.create_buyers(10, Inventory.actual_selling[-1]["ID"],Inventory.sell_id)


func _on_condition_item_selected(index: int) -> void:
	current_text = condition_display.get_item_text(index)

func _process(delta: float) -> void:
	item_count.text = template.format({"items":Inventory.player_selling.size(),"storage":10})

func load_uploaded_item_info() -> void:
	if Inventory.display_item.is_empty():
		return

	var item_data: Dictionary = Inventory.display_item[0]
	price_display.text = ""
	name_display.text = item_data.get("type", "").replace("_", " ").capitalize()
	type_display.text = item_data.get("type", "").replace("_", " ").capitalize()
	#color_display.text = item_data.get("color", "")

	if item_data.get("selected_brand", "none") != "none":
		brand_display.text = item_data.get("selected_brand", "")
	else:
		brand_display.text = item_data.get("brand", "")


func _on_suggest_price_pressed() -> void:
	price_display.text = ""
	if Inventory.display_item.size() >= 1:
		var default_price = Inventory.display_item[0]["default_price"]
		var condition = ""
		if condition_display.selected != -1:
			condition = condition_display.text
		else:
			condition = Inventory.display_item[0]["condition"]
		var brand_mult =  Inventory.display_item[0]["brandmult"]
		var pattern_mult =  Inventory.display_item[0]["pattern_mult"]
		
		var price_mult = 1
		
		if condition == "Poor":
			price_mult = 0.4
		elif condition == "Satisfactory":
			price_mult = 0.6
		elif condition == "Good":
			price_mult = 0.8
		elif condition == "Great":
			price_mult = 0.9
		elif condition == "Minted":
			price_mult = 1.05
		else:
			price_mult = 1.0

		
		var estimate_price = snapped(0.95 * brand_mult * pattern_mult * price_mult * default_price,0.01)
		price_display.text = str(estimate_price)
		
	else:
		exeption_message.text = "Please upload a picture."
