extends Control

@onready var inventory_grid = $inventory/ScrollContainer/GridContainer
@onready var poster_item_container = $poster_item/TextureButton

var item_ui_scene = preload("res://scenes/item_ui.tscn")


func _ready() -> void:
	Inventory.current_ui_type = "poster"
	for item in poster_item_container.get_children():
		item.hide()
	if Inventory.display_poster.size() > 0:
		var poster = poster_item_container.get_node_or_null(Inventory.display_poster[0]["type"])
		if poster != null:
			poster.show()

	load_inventory()


func load_inventory() -> void:
	for child in inventory_grid.get_children():
		child.queue_free()

	for i in range(Inventory.player_inventory.size()):
		var item_data = Inventory.player_inventory[i]
		var item_type = item_data.get("type", "")
		if item_type != "spud_poster" and item_type != "potion_poster":
			continue
		var storage_ui = item_ui_scene.instantiate()
		storage_ui.inventory_index = i
		storage_ui.poster_selected.connect(_on_poster_selected)
		inventory_grid.add_child(storage_ui)


func _on_poster_selected(item_data: Dictionary) -> void:
	for poster in poster_item_container.get_children():
		poster.hide()
	var poster_type: String = item_data.get("type", "")
	var poster = poster_item_container.get_node_or_null(poster_type)
	if poster != null:
		poster.show()


func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/room.tscn")


func _on_put_back_pressed() -> void:
	if Inventory.display_poster.size() > 0:
		Inventory.transfer_item(
					Inventory.display_poster,
					Inventory.player_inventory,
					0
				)
	get_tree().reload_current_scene()
	
