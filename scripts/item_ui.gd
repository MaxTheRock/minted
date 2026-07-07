extends Control

@onready var item = $item
@onready var panel_container = $PanelContainer2
@onready var buy_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Buy_Button
@onready var take_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Take_Button
@onready var place_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Place_Button
@onready var shelf_ui_buttons = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/HBoxContainer
@onready var grid_container = $PanelContainer2/GridContainer
@onready var background = $TextureRect
@onready var put_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Put_Button
@onready var use_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Use_Button
var placeable_items: Array = ["cd_player","camera"]

var inventory_index = 0
	
func _ready() -> void:
	var custom_minumum_size = Vector2(150, 220)

	if Inventory.current_ui_type == "market":
		buy_button.show()
		take_button.hide()
		place_button.hide()
		shelf_ui_buttons.hide()
		put_button.hide()
		use_button.hide()
		grid_container.show()
		item.rarity_ui.connect(_rarity_ui)
		if item.type == "":
			item.initialize_item()
	elif Inventory.current_ui_type == "wardrobe":
		buy_button.hide()
		take_button.show()
		place_button.hide()
		shelf_ui_buttons.hide()
		put_button.hide()
		use_button.hide()
		grid_container.show()
		
		if Inventory.wardrobe_inventory:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.wardrobe_inventory.size():
				item.load_data(Inventory.wardrobe_inventory[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.wardrobe_inventory.size():
				item.load_data(Inventory.wardrobe_inventory[inventory_index])
			
	elif Inventory.current_ui_type == "shelf":
		buy_button.hide()
		take_button.hide()
		place_button.hide()
		shelf_ui_buttons.show()
		put_button.hide()
		use_button.hide()
		grid_container.show()
		
		if Inventory.shelf_inventory:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.shelf_inventory.size():
				item.load_data(Inventory.shelf_inventory[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.shelf_inventory.size():
				item.load_data(Inventory.shelf_inventory[inventory_index])

			
		
				
	elif Inventory.current_ui_type == "place":
		buy_button.hide()
		take_button.hide()
		place_button.show()
		put_button.hide()
		shelf_ui_buttons.hide()
		use_button.hide()
		grid_container.show()
		
		if Inventory.player_inventory:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
		
		var current_item_data = item.get_data()
		if current_item_data.type not in placeable_items:
			place_button.hide()
			
		
	elif Inventory.current_ui_type == "player":
		buy_button.hide()
		take_button.hide()
		place_button.hide()
		put_button.hide()
		shelf_ui_buttons.hide()
		use_button.hide()
		grid_container.hide()
		panel_container.custom_maximum_size = Vector2(150,160)
		$TextureRect.custom_maximum_size = Vector2(150,158)
		
		if Inventory.player_inventory:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
		
		
	elif Inventory.current_ui_type == "inventory_wardrobe":
		buy_button.hide()
		take_button.hide()
		place_button.hide()
		put_button.show()
		use_button.hide()
		shelf_ui_buttons.hide()
		if Inventory.player_inventory:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
	
	elif Inventory.current_ui_type == "cd_player":
		buy_button.hide()
		take_button.hide()
		place_button.hide()
		put_button.hide()
		shelf_ui_buttons.hide()
		use_button.show()
		grid_container.show()
		
		if Inventory.player_inventory:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
				if !(item.cd):
					queue_free()
					return
			
func _rarity_ui(item_rarity) -> void:
	if item_rarity == "common":
		background.self_modulate = Color("616161ff")
		panel_container.self_modulate = Color8(245,255,255)
	elif item_rarity == "uncommon":
		panel_container.self_modulate = Color8(20,235,30)
		background.self_modulate = Color("346634ff")
	elif item_rarity == "rare":
		panel_container.self_modulate = Color8(54,136,177)
		background.self_modulate = Color("a31847ff")
	elif item_rarity == "epic":
		panel_container.self_modulate = Color8(153,51,255)
		background.self_modulate = Color("89377cff")

func _on_buy_button_mouse_entered() -> void:
	item.button_enter()

func _on_buy_button_mouse_exited() -> void:
	item.button_exit()

func _on_buy_button_pressed() -> void:
	if Global.money < item.price:
		return
	Global.money -= item.price
	Inventory.wardrobe_inventory.append(item.get_data())
	queue_free()


func _on_take_button_mouse_entered() -> void:
	item.button_enter()


func _on_take_button_mouse_exited() -> void:
	item.button_exit()


func _on_take_button_pressed() -> void:
	if Inventory.player_inventory.size() <= 1:
		var current_item_data = item.get_data()
		inventory_index = Inventory.wardrobe_inventory.find(current_item_data)
		Inventory.transfer_item(Inventory.wardrobe_inventory,
		Inventory.player_inventory, inventory_index)
		queue_free()
		get_tree().reload_current_scene()
	else:
		print("Cannot carry any more items!")



func _on_put_button_button_down() -> void:
	item.button_enter()


func _on_put_button_button_up() -> void:
	item.button_exit()


func _on_put_button_pressed() -> void:
	if Inventory.wardrobe_inventory.size() <= Global.storage_capacity:
		var current_item_data = item.get_data()
		inventory_index = Inventory.player_inventory.find(current_item_data)
		Inventory.transfer_item(Inventory.player_inventory,
		Inventory.wardrobe_inventory, inventory_index)
		queue_free()
		get_tree().reload_current_scene()
	else:
		print("Wardrobe cannot annot carry any more items!")



func _on_place_button_button_down() -> void:
	item.button_enter()


func _on_place_button_button_up() -> void:
	item.button_exit()


func _on_place_button_pressed() -> void:
	if Inventory.shelf_inventory.size() <= 5:
		var current_item_data = item.get_data()
		inventory_index = Inventory.player_inventory.find(current_item_data)
		Inventory.transfer_item(Inventory.player_inventory,
		Inventory.shelf_inventory, inventory_index)
		queue_free()
		get_tree().reload_current_scene()
	else:
		print("Shelf cannot annot carry any more items!")



func _on_remove_button_down() -> void:
	item.button_enter()


func _on_remove_button_up() -> void:
	item.button_exit()


func _on_remove_pressed() -> void:
	if Inventory.player_inventory.size() <= 1:
		var current_item_data = item.get_data()
		inventory_index = Inventory.shelf_inventory.find(current_item_data)
		Inventory.transfer_item(Inventory.shelf_inventory,
		Inventory.player_inventory, inventory_index)
		queue_free()
		get_tree().reload_current_scene()
	else:
		print("Cannot carry any more items!")


func _on_use_pressed() -> void:
	print(item.type)
	if item.type == "cd_player":
		get_tree().change_scene_to_file("res://scenes/cd_player.tscn")


func _on_use_button_pressed() -> void:
	if Inventory.cd_inventory.size() < 1:
		Global.now_playing = str(item.type)
		if item.condition == "Poor":
			AudioManager.music_player.bus = "LowQuality"
		else:
			AudioManager.music_player.bus = "Master"
		if item.type == "the_big_mint":
			AudioManager.play_music(AudioManager.the_big_mint)
		elif item.type == "smooth_jazz_1":
			AudioManager.play_music(AudioManager.smooth_jazz_1)
		elif item.type == "evil_pulsation":
			AudioManager.play_music(AudioManager.evil_pulsation)
		elif item.type == "jungle":
			AudioManager.play_music(AudioManager.jungle)
		elif item.type == "three_jelly":
			AudioManager.play_music(AudioManager.three_jelly)
		
		var current_item_data = item.get_data()
		inventory_index = Inventory.player_inventory.find(current_item_data)
		Inventory.transfer_item(Inventory.player_inventory,
		Inventory.cd_inventory, inventory_index)
		queue_free()
		get_tree().reload_current_scene()
	else:
		print("there is a cd in use!")
		
