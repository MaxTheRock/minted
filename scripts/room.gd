extends Node2D

@onready var grid = $inventory/ScrollContainer/GridContainer
@onready var player = $player/Player

func _ready() -> void:
	Inventory.current_ui_type = "player"
	player.global_position.x = Global.player_saved_x
	player.global_position.y = Global.player_saved_y

	for i in range(Inventory.player_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		grid.add_child(storage_ui)

func _process(float) -> void:
	Global.player_saved_x = player.global_position.x
	Global.player_saved_y = player.global_position.y
	
	
