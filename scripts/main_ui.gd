extends Control

@onready var money_ui_element = $Market/VBoxContainer/PanelContainer/Right/Money_Container/Money

func show_page(page_name):
	for child in get_children():
		child.visible = false
	get_node(page_name).visible = true

func _on_button_pressed() -> void:
	show_page("Market")

func generate_items(grid: GridContainer, category: String, amount: int):
	var packed = preload("res://scenes/item_ui.tscn")

	for i in range(amount):
		var item_ui = packed.instantiate()
		grid.add_child(item_ui)
		item_ui.get_node("item").initialize_item(category)
	
func _ready():
	generate_items($Market/VBoxContainer/Sections/Centre/TabContainer/All/ScrollContainer/GridContainer, "All", 15)
	generate_items($Market/VBoxContainer/Sections/Centre/TabContainer/Clothes/ScrollContainer/GridContainer, "Clothes", 15)
	generate_items($Market/VBoxContainer/Sections/Centre/TabContainer/Toys/ScrollContainer/GridContainer, "Toys", 15)
	generate_items($Market/VBoxContainer/Sections/Centre/TabContainer/Home/ScrollContainer/GridContainer, "Home", 15)
	generate_items($Market/VBoxContainer/Sections/Centre/TabContainer/Electronics/ScrollContainer/GridContainer, "Electronics", 15)
	generate_items($Market/VBoxContainer/Sections/Centre/TabContainer/BooksMedia/ScrollContainer/GridContainer, "BooksMedia", 15)
	generate_items($Market/VBoxContainer/Sections/Centre/TabContainer/Collectables/ScrollContainer/GridContainer, "Collectables", 15)
	generate_items($Market/VBoxContainer/Sections/Centre/TabContainer/Sports/ScrollContainer/GridContainer, "Sports", 15)
	
func _process(delta: float) -> void:
	money_ui_element.text = "$" + str(Global.money)
