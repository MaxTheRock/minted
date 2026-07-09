extends Control

@onready var grid = $items/ScrollContainer/GridContainer
@onready var inventory_grid = $inventory/ScrollContainer/GridContainer

func _ready() -> void:
	Global.inShelf = false
	Global.inWardrobe = true
	Inventory.current_ui_type = "parcel"

	for i in range(ShippingHandler.delivered_list.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		storage_ui.is_parcel = true
		grid.add_child(storage_ui)
	
	Inventory.current_ui_type = "player"
	for i in range(Inventory.player_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		inventory_grid.add_child(storage_ui)

func _on_close_pressed() -> void:
	Global.inWardrobe = false
	get_tree().change_scene_to_file("res://scenes/room.tscn")
