extends Control

@onready var storage = $storage
var current_position = position
@onready var grid = $inventory/ScrollContainer/MarginContainer/GridContainer
func _ready():
	if get_tree().current_scene.scene_file_path == "res://scenes/room.tscn":
		Inventory.current_ui_type = "player"
		grid.add_theme_constant_override("v_separation", -50)
	elif get_tree().current_scene.scene_file_path == "res://scenes/storage.tscn":
		Inventory.current_ui_type = "inventory_wardrobe"
		grid.add_theme_constant_override("v_separation", -10)
		
		
	for i in range(Inventory.player_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		grid.add_child(storage_ui)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	storage.text = "Storage: " + str(Inventory.player_inventory_weight) + "/" + str(Inventory.player_max)
	
	if get_tree().current_scene.scene_file_path == "res://scenes/room.tscn":
		grid.columns = 6
		if Inventory.player_inventory.size() >= 3:
			$inventory.size = Vector2(130,50)
		else:
			$inventory.size = Vector2(90,50)
	else:
		grid.columns = 2
		if Inventory.player_inventory.size() >= 3:
			$inventory.size = Vector2(100,120)
		elif Inventory.player_inventory.size() >= 5:
			$inventory.size = Vector2(100,170)
		else:
			$inventory.size = Vector2(100,70)
