extends Node2D

@onready var grid = $inventory/ScrollContainer/GridContainer


func _ready() -> void:
	Inventory.current_ui_type = "player"

	for i in range(Inventory.player_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		grid.add_child(storage_ui)
