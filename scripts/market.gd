extends Control

@onready var selected = $VBoxContainer/Sections/Centre/TabContainer
@onready var progress = $Button/TextureProgressBar

@onready var grids: Dictionary = {
	"All": $VBoxContainer/Sections/Centre/TabContainer/All/ScrollContainer/GridContainer,
	"Clothes": $VBoxContainer/Sections/Centre/TabContainer/Clothes/ScrollContainer/GridContainer,
	"Toys": $VBoxContainer/Sections/Centre/TabContainer/Toys/ScrollContainer/GridContainer,
	"Electronics": $VBoxContainer/Sections/Centre/TabContainer/Electronics/ScrollContainer/GridContainer,
	"Home": $VBoxContainer/Sections/Centre/TabContainer/Home/ScrollContainer/GridContainer,
	"BooksMedia": $VBoxContainer/Sections/Centre/TabContainer/BooksMedia/ScrollContainer/GridContainer,
	"Collectables": $VBoxContainer/Sections/Centre/TabContainer/Collectables/ScrollContainer/GridContainer,
	"Sports": $VBoxContainer/Sections/Centre/TabContainer/Sports/ScrollContainer/GridContainer
}

var packed = preload("res://scenes/item_ui.tscn")

func _ready() -> void:
	Global.inShelf = false
	Global.inWardrobe = false
	SignalBus.refresh_market.connect(reload_page)

func _on_button_pressed() -> void:
	var category = Inventory.current_market_type
	if category != "" and Global.refreshProgress >= 100:
		Inventory.current_ui_type = "market"
		Inventory.market_items[category] = []
		progress.value = 0
		Global.refreshProgress = 0
		Global.rent_broadband += 0.02 * Global.rent_broadband_mult
		Inventory.refresh_buyer_market(category)

		if grids.has(category):
			var grid = grids[category]
			for child in grid.get_children():
				child.queue_free()

			for i in range(15):
				var item_ui = packed.instantiate()
				grid.add_child(item_ui)
				item_ui.get_node("item").initialize_item(category)
				item_ui.market_type = category
				Inventory.market_items[category].append(item_ui.get_data())

func _on_tab_container_tab_selected(tab: int) -> void:
	if selected:
		Inventory.current_market_type = selected.get_tab_title(tab)

func _process(_delta: float) -> void:
	if Global.refreshProgress >= 100:
		progress.hide()
	else:
		progress.show()

	progress.value = min(Global.refreshProgress, 100)

func generate_items(grid: GridContainer, category: String) -> void:
	Inventory.current_ui_type = "market"
	for child in grid.get_children():
		child.queue_free()

	if not Inventory.market_items.has(category):
		return

	for data in Inventory.market_items[category]:
		var item_ui = packed.instantiate()
		item_ui.market_type = category
		grid.add_child(item_ui)
		item_ui.get_node("item").load_data(data)

func reload_page(category) -> void:
	if grids.has(category):
		generate_items(grids[category], category)
