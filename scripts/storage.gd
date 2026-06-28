extends Control

@onready var inv_label = $VBoxContainer/Inventory_test

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	inv_label.text = str(Global.inventory)

func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/room.tscn")
