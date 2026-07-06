extends Control

var colours: Array = ["white","yellow", "red", "green", "blue", "black", "purple", "pink", "cyan", "orange"]
var trouser_colours: Array = ["white", "black", "grey", "blue", "green"]

@onready var inv_label = $Inventory_test
@onready var grid = $items/ScrollContainer/GridContainer
@onready var inventory_grid = $inventory/ScrollContainer/GridContainer

func _ready() -> void:
	Global.inShelf = false
	Global.inWardrobe = true
	Inventory.current_ui_type = "wardrobe"
	inv_label.text = "Storage: " + str(Inventory.wardrobe_inventory.size()) + "/" + str(Global.storage_capacity)

	for i in range(Inventory.wardrobe_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		grid.add_child(storage_ui)
	
	Inventory.current_ui_type = "inventory_wardrobe"
	for i in range(Inventory.player_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		inventory_grid.add_child(storage_ui)

func _on_close_pressed() -> void:
	Global.inWardrobe = false
	get_tree().change_scene_to_file("res://scenes/room.tscn")
