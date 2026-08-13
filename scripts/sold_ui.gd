extends Control

var show_info: bool = false
var item_index = 0

@onready var info = $info
@onready var info_container = $PanelContainer2
@onready var item_container = $MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_info = false
	var packed = preload("res://scenes/item_ui.tscn")
	var storage_ui = packed.instantiate()
	storage_ui.inventory_index = item_index
	item_container.add_child(storage_ui)
	
	print(Inventory.sold_items[item_index])
	if Inventory.sold_items[item_index]["price"]:
		$price/name/price.text = "$" + str(Inventory.sold_items[item_index]["price"])
	if Inventory.sold_items[item_index]["name"]:
		$item_name/name/ScrollContainer/name.text = Inventory.sold_items[item_index]["name"]
	if Inventory.sold_items[item_index]["brand"]:
		$info/brand/brand_label.text = Inventory.sold_items[item_index]["brand"]
	if Inventory.sold_items[item_index]["color"]:
		$info/color/color_label.text = Inventory.sold_items[item_index]["color"]
	if Inventory.sold_items[item_index]["condition"]:
		$info/condition/condition_label.text = Inventory.sold_items[item_index]["condition"]
	if Inventory.sold_items[item_index]["type"]:
		$info/type/type_label.text = Inventory.sold_items[item_index]["type"]
	if Inventory.sold_items[item_index]["buyer_name"]:
		$user_info/username/username_label.text = Inventory.sold_items[item_index]["buyer_name"]
	else:
		$user_info/username/username_label.text = "Unknown Buyer"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if show_info:
		info_container.size = Vector2(500,150)
		info.show()
	else:
		info_container.size = Vector2(500,60)
		info.hide()


func _on_info_button_pressed() -> void:
	show_info = !show_info
