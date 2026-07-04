extends Control

var colours: Array = ["white","yellow", "red", "green", "blue", "black", "purple", "pink", "cyan", "orange"]
var trouser_colours: Array = ["white", "black", "grey", "blue", "green"]

@onready var inv_label = $Inventory_test
@onready var grid = $items/ScrollContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.inWardrobe = true
	inv_label.text = "Storage: " + str(Global.inventory.size()) + "/" + str(Global.storage_capacity)
	for i in range(Global.inventory.size()):
		var packed = preload("res://scenes/storage_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		grid.add_child(storage_ui)
	

func _on_close_pressed() -> void:
	Global.inWardrobe = false
	get_tree().change_scene_to_file("res://scenes/room.tscn")
