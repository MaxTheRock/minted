extends Control

var colours: Array = ["white","yellow", "red", "green", "blue", "black", "purple", "pink", "cyan", "orange"]
var trouser_colours: Array = ["white", "black", "grey", "blue", "green"]

@onready var grid = $items/ScrollContainer/GridContainer

func _ready() -> void:
	Global.inShelf = true
	for i in range(Global.inventory.size()):
		if Global.inventory[i]["type"] == "cd_player":
			var packed = preload("res://scenes/item_ui.tscn")
			var shelf_ui = packed.instantiate()
			shelf_ui.inventory_index = i
			grid.add_child(shelf_ui)


func _process(delta: float) -> void:
	pass
