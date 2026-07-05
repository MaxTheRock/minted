extends Control

@onready var item = $item
@onready var panel_container = $PanelContainer2
@onready var take_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Take_Button
@onready var background = $TextureRect
const StorageItemScene = preload("res://scenes/storage_ui.tscn")

var inventory_index = 0


func _ready() -> void:
	if Global.inShelf == true and Global.shelf_inventory:
		item.rarity_ui.connect(_rarity_ui)
		if inventory_index >= 0 and inventory_index < Global.shelf_inventory.size():
			item.load_data(Global.shelf_inventory[inventory_index])
	else:
		item.rarity_ui.connect(_rarity_ui)
		if inventory_index >= 0 and inventory_index < Global.inventory.size():
			item.load_data(Global.inventory[inventory_index])

func _rarity_ui(item_rarity) -> void:
	if item_rarity == "common":
		background.self_modulate = Color("616161ff")
		panel_container.self_modulate = Color8(245,255,255)
	elif item_rarity == "uncommon":
		panel_container.self_modulate = Color8(20,235,30)
		background.self_modulate = Color("346634ff")
	elif item_rarity == "rare":
		panel_container.self_modulate = Color8(54,136,177)
		background.self_modulate = Color("a31847ff")
	elif item_rarity == "epic":
		panel_container.self_modulate = Color8(153,51,255)
		background.self_modulate = Color("89377cff")


func _on_place_button_pressed() -> void:
	Global.shelf_inventory.append(item.get_data())
	Global.inventory.erase(item.get_data())
	get_tree().change_scene_to_file("res://scenes/shelf.tscn")
