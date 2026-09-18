extends Control

@onready var storage = $storage
var current_position = position
@onready var grid = $inventory/ScrollContainer/MarginContainer/GridContainer
var item_ui_scene = preload("res://scenes/item_ui.tscn")

func _ready():
	if get_tree().current_scene.scene_file_path == "res://scenes/room.tscn" or get_tree().current_scene.scene_file_path == "res://scenes/parcel.tscn":
		Inventory.current_ui_type = "player"
		grid.add_theme_constant_override("v_separation", -50)
		grid.columns = 6
	elif get_tree().current_scene.scene_file_path == "res://scenes/storage.tscn":
		Inventory.current_ui_type = "inventory_wardrobe"
		grid.add_theme_constant_override("v_separation", -10)
		grid.columns = 2
	elif get_tree().current_scene.scene_file_path == "res://scenes/shelf.tscn":
		Inventory.current_ui_type = "place"
		grid.add_theme_constant_override("v_separation", -10)
		grid.columns = 2
	elif get_tree().current_scene.scene_file_path == "res://scenes/poster_menu.tscn":
		Inventory.current_ui_type = "poster"
		grid.add_theme_constant_override("v_separation", -10)
		grid.columns = 2

	if Inventory.current_ui_type != "poster":
		for i in range(Inventory.player_inventory.size()):
			var packed = preload("res://scenes/item_ui.tscn")
			var storage_ui = packed.instantiate()
			storage_ui.inventory_index = i
			grid.add_child(storage_ui)
	else:
		for i in range(Inventory.player_inventory.size()):
			var item_data = Inventory.player_inventory[i]
			var item_type = item_data.get("type", "")
			var category = item_data.get("catergory", "")

			var storage_ui = item_ui_scene.instantiate()
			storage_ui.inventory_index = i
			storage_ui.poster_selected.connect(_on_poster_selected)
			grid.add_child(storage_ui)

func _process(_delta: float) -> void:
	storage.text = "Storage: " + str(Inventory.player_inventory_weight) + "/" + str(Inventory.player_max)

func _on_poster_selected(_item_data: Dictionary) -> void:
	get_tree().reload_current_scene()
