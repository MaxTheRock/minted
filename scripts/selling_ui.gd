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
	
	print(Inventory.player_selling[item_index])
	if Inventory.player_selling[item_index]["price"]:
		$price/name/price.text = "$" + str(Inventory.player_selling[item_index]["price"])
	if Inventory.player_selling[item_index]["name"]:
		$item_name/name/name.text = Inventory.player_selling[item_index]["name"]
	if Inventory.player_selling[item_index]["brand"]:
		$info/brand/brand_label.text = Inventory.player_selling[item_index]["brand"]
	if Inventory.player_selling[item_index]["color"]:
		$info/color/color_label.text = Inventory.player_selling[item_index]["color"]
	if Inventory.player_selling[item_index]["condition"]:
		$info/condition/condition_label.text = Inventory.player_selling[item_index]["condition"]
	if Inventory.player_selling[item_index]["type"]:
		$info/type/type_label.text = Inventory.player_selling[item_index]["type"]


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


func _on_clear_pressed() -> void:
	Inventory.player_selling.pop_at(item_index)
	Inventory.actual_selling.pop_at(item_index)
	queue_free()
