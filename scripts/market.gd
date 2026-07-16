extends Control

@onready var selected = $VBoxContainer/Sections/Centre/TabContainer
@onready var progress = $Button/TextureProgressBar

@onready var all = $VBoxContainer/Sections/Centre/TabContainer/All/ScrollContainer/GridContainer
@onready var clothes = $VBoxContainer/Sections/Centre/TabContainer/Clothes/ScrollContainer/GridContainer
@onready var toys = $VBoxContainer/Sections/Centre/TabContainer/Toys/ScrollContainer/GridContainer
@onready var electronics = $VBoxContainer/Sections/Centre/TabContainer/Electronics/ScrollContainer/GridContainer
@onready var home = $VBoxContainer/Sections/Centre/TabContainer/Home/ScrollContainer/GridContainer
@onready var booksmedia = $VBoxContainer/Sections/Centre/TabContainer/BooksMedia/ScrollContainer/GridContainer
@onready var collectables = $VBoxContainer/Sections/Centre/TabContainer/Collectables/ScrollContainer/GridContainer
@onready var sports = $VBoxContainer/Sections/Centre/TabContainer/Sports/ScrollContainer/GridContainer


func _ready() -> void:
	Global.inShelf = false
	Global.inWardrobe = false

func _on_button_pressed() -> void:
	if Inventory.current_market_type != "" and Global.refreshProgress >= 100:
		Inventory.current_ui_type = "market"
		Inventory.market_items[Inventory.current_market_type] = []
		progress.value = 0
		Global.refreshProgress = 0
		var packed = preload("res://scenes/item_ui.tscn")
		var category = Inventory.current_market_type
		
		# idk how to do this without a big if statement, oh well. :/
		if category == "All":
			for child in all.get_children():
				child.queue_free()
			for i in range(15):
				var item_ui = packed.instantiate()
				all.add_child(item_ui)
				item_ui.get_node("item").initialize_item(category)
				item_ui.market_type = category
				Inventory.market_items[category].append(item_ui.get_data())
				
		elif category == "Clothes":
			for child in clothes.get_children():
				child.queue_free()
			for i in range(15):
				var item_ui = packed.instantiate()
				clothes.add_child(item_ui)
				item_ui.get_node("item").initialize_item(category)
				item_ui.market_type = category
				Inventory.market_items[category].append(item_ui.get_data())
				
		elif category == "Toys":
			for child in toys.get_children():
				child.queue_free()
			for i in range(15):
				var item_ui = packed.instantiate()
				toys.add_child(item_ui)
				item_ui.get_node("item").initialize_item(category)
				item_ui.market_type = category
				Inventory.market_items[category].append(item_ui.get_data())
				
		elif category == "Home":
			for child in home.get_children():
				child.queue_free()
			for i in range(15):
				var item_ui = packed.instantiate()
				home.add_child(item_ui)
				item_ui.get_node("item").initialize_item(category)
				item_ui.market_type = category
				Inventory.market_items[category].append(item_ui.get_data())
		
		elif category == "Electronics":
			for child in electronics.get_children():
				child.queue_free()
			for i in range(15):
				var item_ui = packed.instantiate()
				electronics.add_child(item_ui)
				item_ui.get_node("item").initialize_item(category)
				item_ui.market_type = category
				Inventory.market_items[category].append(item_ui.get_data())
		
		elif category == "BooksMedia":
			for child in booksmedia.get_children():
				child.queue_free()
			for i in range(15):
				var item_ui = packed.instantiate()
				booksmedia.add_child(item_ui)
				item_ui.get_node("item").initialize_item(category)
				item_ui.market_type = category
				Inventory.market_items[category].append(item_ui.get_data())
		
		elif category == "Collectables":
			for child in collectables.get_children():
				child.queue_free()
			for i in range(15):
				var item_ui = packed.instantiate()
				collectables.add_child(item_ui)
				item_ui.get_node("item").initialize_item(category)
				item_ui.market_type = category
				Inventory.market_items[category].append(item_ui.get_data())
		
		elif category == "Sports":
			for child in sports.get_children():
				child.queue_free()
			for i in range(15):
				var item_ui = packed.instantiate()
				sports.add_child(item_ui)
				item_ui.get_node("item").initialize_item(category)
				item_ui.market_type = category
				Inventory.market_items[category].append(item_ui.get_data())



func _on_tab_container_tab_selected(tab: int) -> void:
	if selected:
		Inventory.current_market_type = selected.get_tab_title(tab)
		print("active market category: ", Inventory.current_market_type)

func _process(delta: float) -> void:
	if Global.refreshProgress >= 100:
		progress.hide()
	else:
		progress.show()

	progress.value = min(Global.refreshProgress,100)
