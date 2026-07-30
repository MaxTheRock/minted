extends Control

@onready var money_ui_element = $Mintora/VBoxContainer/Control3/TabContainer/Home/Market/VBoxContainer/PanelContainer/Right/Money_Container/Money
@onready var ui_element = preload("res://scenes/item_ui.tscn")
@onready var tab_container = $Mintora/VBoxContainer/Control3/TabContainer

func show_page(page_name: String) -> void:
	for i in range(tab_container.get_tab_count()):
		if tab_container.get_tab_title(i) == page_name or tab_container.get_child(i).name == page_name:
			tab_container.current_tab = i
			return

func _on_button_pressed() -> void:
	show_page("Market")

func generate_items(grid: GridContainer, category: String, amount: int):
	Inventory.current_ui_type = "market"
	var packed = preload("res://scenes/item_ui.tscn")
	
	if not Inventory.market_items.has(category):
		Inventory.market_items[category] = []
		for i in range(amount):
			var item_ui = packed.instantiate()
			grid.add_child(item_ui)
			item_ui.get_node("item").initialize_item(category)
			item_ui.market_type = category
			Inventory.market_items[category].append(item_ui.get_data())
	else:
		for data in Inventory.market_items[category]:
			var item_ui = packed.instantiate()
			item_ui.market_type = category
			grid.add_child(item_ui)
			item_ui.get_node("item").load_data(data)
			
func _ready():
	$Mintora/VBoxContainer/Control3/TabContainer/Selling/selling.page_requested.connect(show_page)
	generate_items($Mintora/VBoxContainer/Control3/TabContainer/Home/Market/VBoxContainer/Sections/Centre/TabContainer/All/ScrollContainer/GridContainer, "All", 15)
	generate_items($Mintora/VBoxContainer/Control3/TabContainer/Home/Market/VBoxContainer/Sections/Centre/TabContainer/Clothes/ScrollContainer/GridContainer, "Clothes", 15)
	generate_items($Mintora/VBoxContainer/Control3/TabContainer/Home/Market/VBoxContainer/Sections/Centre/TabContainer/Toys/ScrollContainer/GridContainer, "Toys", 15)
	generate_items($Mintora/VBoxContainer/Control3/TabContainer/Home/Market/VBoxContainer/Sections/Centre/TabContainer/Home/ScrollContainer/GridContainer, "Home", 15)
	generate_items($Mintora/VBoxContainer/Control3/TabContainer/Home/Market/VBoxContainer/Sections/Centre/TabContainer/Electronics/ScrollContainer/GridContainer, "Electronics", 15)
	generate_items($Mintora/VBoxContainer/Control3/TabContainer/Home/Market/VBoxContainer/Sections/Centre/TabContainer/BooksMedia/ScrollContainer/GridContainer, "BooksMedia", 15)
	generate_items($Mintora/VBoxContainer/Control3/TabContainer/Home/Market/VBoxContainer/Sections/Centre/TabContainer/Collectables/ScrollContainer/GridContainer, "Collectables", 15)
	generate_items($Mintora/VBoxContainer/Control3/TabContainer/Home/Market/VBoxContainer/Sections/Centre/TabContainer/Sports/ScrollContainer/GridContainer, "Sports", 15)
