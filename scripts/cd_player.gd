extends Control

@onready var inventory_grid = $inventory/ScrollContainer/GridContainer
@onready var cd_player = $cd_player
@onready var now_playing_text = $now_playing_text

var bounce_time = 0.0

func _ready() -> void:
	Inventory.current_ui_type = "cd_player"

	for i in range(Inventory.wardrobe_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		inventory_grid.add_child(storage_ui)

func _process(delta: float) -> void:
	now_playing_text.text = "Now Playing: " + Global.now_playing
	if Global.now_playing != "":
		bounce_time += delta * 6.0
		var bounce = sin(bounce_time) * 0.2
		cd_player.scale = Vector2(
			10.0 + bounce,
			10.0 - bounce * 0.5
		)
		
func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shelf.tscn")
