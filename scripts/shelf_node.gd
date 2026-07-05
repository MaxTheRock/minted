extends Control

var cd_player_placable = false
var cd_player_placed = false

func _ready() -> void:
	for item in Global.inventory:
		if item["type"] == "cd_player":
			cd_player_placable = true

func _process(delta: float) -> void:
	pass


func _on_close_pressed() -> void:
	Global.inShelf = false
	get_tree().change_scene_to_file("res://scenes/room.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shelf_item_select.tscn")
