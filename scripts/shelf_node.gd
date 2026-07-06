extends Control

@onready var grid = $items/ScrollContainer/GridContainer
@onready var inventory_grid = $inventory/ScrollContainer/GridContainer

func _ready() -> void:
	Global.inShelf = true
	Global.inWardrobe = false
	Inventory.current_ui_type = "shelf"

	for i in range(Inventory.shelf_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		grid.add_child(storage_ui)
	
	Inventory.current_ui_type = "place"
	for i in range(Inventory.player_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		inventory_grid.add_child(storage_ui)



func _on_close_pressed() -> void:
	Global.inShelf = false
	get_tree().change_scene_to_file("res://scenes/room.tscn")
