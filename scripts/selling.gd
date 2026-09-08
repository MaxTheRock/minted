extends Control

signal page_requested(page_name: String)

const SELLING_UI_SCENE := preload("res://scenes/selling_ui.tscn")
const SOLD_UI_SCENE := preload("res://scenes/sold_ui.tscn")

@onready var sell_item: SellItemForm = $"Sections/Centre/TabContainer/Sell Item/sell_item"
@onready var selling_display: GridContainer = $Sections/Centre/TabContainer/sell_list/ScrollContainer/GridContainer
@onready var sold_display: GridContainer = $Sections/Centre/TabContainer/sold_list/ScrollContainer/GridContainer
@onready var item_count: Label = $Sections/Centre/TabContainer/sell_list/Label

var template := "Items: {items}/{storage}"


func _ready() -> void:
	Inventory.item_sold.connect(_build_lists)
	sell_item.sell_requested.connect(_on_sell_item_sell_requested)
	sell_item.page_requested.connect(_on_sell_item_page_requested)
	_build_lists()


func _process(_delta: float) -> void:
	item_count.text = template.format({"items": Inventory.player_selling.size(), "storage": 10})


func _build_lists() -> void:
	for child in selling_display.get_children():
		child.queue_free()
	for child in sold_display.get_children():
		child.queue_free()

	Inventory.current_ui_type = "display_selling"
	for i in range(Inventory.actual_selling.size()):
		var listing_ui = SELLING_UI_SCENE.instantiate()
		listing_ui.item_index = i
		selling_display.add_child(listing_ui)

	Inventory.current_ui_type = "display_sold"
	for i in range(Inventory.actual_sold.size()):
		var sold_ui = SOLD_UI_SCENE.instantiate()
		sold_ui.item_index = i
		sold_display.add_child(sold_ui)


func _on_sell_item_page_requested(page_name: String) -> void:
	_build_lists()
	page_requested.emit(page_name)


func _on_sell_item_sell_requested(item_data: Dictionary) -> void:
	var listing: Dictionary = Inventory.display_item[0].duplicate()
	Inventory.sell_id += 1
	listing["listing_sell_id"] = Inventory.sell_id
	Inventory.remove_from_inventory(listing["ID"])
	Inventory.transfer_item([listing], Inventory.actual_selling, 0)

	Inventory.player_selling.append(item_data)

	sell_item.clear_form()
	sell_item.rebuild_inventory()
	_build_lists()

	Inventory.create_buyers(10, Inventory.actual_selling[-1]["ID"], Inventory.sell_id)
