extends Control

var colours: Array = ["white","yellow", "red", "green", "blue", "black", "purple", "pink", "cyan", "orange"]
var trouser_colours: Array = ["white", "black", "grey", "blue", "green"]

@onready var inv_label = $Inventory_test
@onready var grid = $items/ScrollContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(Global.inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var item_ui = packed.instantiate()
		grid.add_child(item_ui)
	

func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/room.tscn")
