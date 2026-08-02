extends Node2D

@onready var grid = $inventory/ScrollContainer/GridContainer
@onready var player = $player/Player
@onready var sleep_bar = $sleep/sleep_bar
@onready var time_ui = $sleep/timer/Time

func _ready() -> void:
	Inventory.current_ui_type = "player"
	player.global_position.x = Global.player_saved_x
	player.global_position.y = Global.player_saved_y
	if Global.first_room:
		Global.dialogue_ongoing = true
		await get_tree().create_timer(1.0).timeout
		SignalBus.display_dialogue.emit("find",0)

	for i in range(Inventory.player_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		grid.add_child(storage_ui)

func _process(float) -> void:
	sleep_bar.value = Global.sleep
	time_ui.text = Global.get_time_text()
	Global.player_saved_x = player.global_position.x
	Global.player_saved_y = player.global_position.y
	
	
