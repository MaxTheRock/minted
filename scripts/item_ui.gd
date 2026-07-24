extends Control

@onready var item = $item
@onready var panel_container = $PanelContainer2
@onready var buy_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Buy_Button
@onready var take_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Take_Button
@onready var place_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Place_Button
@onready var shelf_ui_buttons = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/HBoxContainer
@onready var grid_container = $PanelContainer2/GridContainer
@onready var eject_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/cd_playing
@onready var background = $TextureRect
@onready var put_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Put_Button
@onready var use_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Use_Button
@onready var upload_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Upload_Button
signal page_requested(page_name: String) 

var placeable_items: Array = ["cd_player","camera"]
var market_type = ""

var inventory_index = 0
var is_parcel = false
	
func _ready() -> void:
	var custom_minumum_size = Vector2(150, 220)

	if Inventory.current_ui_type == "market":
		buy_button.show()
		take_button.hide()
		place_button.hide()
		shelf_ui_buttons.hide()
		put_button.hide()
		use_button.hide()
		eject_button.hide()
		upload_button.hide()
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
		eject_button.hide()
		upload_button.hide()
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
		eject_button.hide()
		upload_button.hide()
		grid_container.show()
		
		if Inventory.shelf_inventory:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.shelf_inventory.size():
				item.load_data(Inventory.shelf_inventory[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.shelf_inventory.size():
				item.load_data(Inventory.shelf_inventory[inventory_index])
		
		if item.type == "cd_player" and Inventory.cd_inventory.size() == 1:
			eject_button.show()
			shelf_ui_buttons.hide()
		
				
	elif Inventory.current_ui_type == "place":
		buy_button.hide()
		take_button.hide()
		place_button.show()
		put_button.hide()
		shelf_ui_buttons.hide()
		use_button.hide()
		eject_button.hide()
		upload_button.hide()
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
		eject_button.hide()
		grid_container.hide()
		upload_button.hide()
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
		eject_button.hide()
		use_button.hide()
		upload_button.hide()
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
		eject_button.hide()
		upload_button.hide()
		grid_container.show()
		
		if Inventory.player_inventory:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
				if !(item.cd):
					queue_free()
					return
	
	elif Inventory.current_ui_type == "selling":
		buy_button.hide()
		take_button.hide()
		place_button.hide()
		put_button.hide()
		shelf_ui_buttons.hide()
		use_button.hide()
		eject_button.hide()
		upload_button.show()
		grid_container.show()
		
		if Inventory.display_item:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
	
	elif Inventory.current_ui_type == "shipping":
		buy_button.hide()
		take_button.hide()
		place_button.hide()
		put_button.hide()
		shelf_ui_buttons.hide()
		use_button.hide()
		eject_button.hide()
		grid_container.hide()
		upload_button.hide()
		panel_container.custom_maximum_size = Vector2(150,160)
		$TextureRect.custom_maximum_size = Vector2(150,158)
	
	elif Inventory.current_ui_type == "parcel":
		buy_button.hide()
		take_button.show()
		place_button.hide()
		shelf_ui_buttons.hide()
		put_button.hide()
		use_button.hide()
		eject_button.hide()
		upload_button.hide()
		grid_container.show()
		
		if ShippingHandler.delivered_list:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < ShippingHandler.delivered_list.size():
				item.load_data(ShippingHandler.delivered_list[inventory_index][0])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < ShippingHandler.delivered_list.size():
				item.load_data(ShippingHandler.delivered_list[inventory_index][0])
	
	elif Inventory.current_ui_type == "display_selling":
		buy_button.hide()
		take_button.hide()
		place_button.hide()
		put_button.hide()
		shelf_ui_buttons.hide()
		use_button.hide()
		eject_button.hide()
		grid_container.hide()
		upload_button.hide()
		panel_container.custom_maximum_size = Vector2(150,160)
		$TextureRect.custom_maximum_size = Vector2(150,158)
		
		if Inventory.actual_selling:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.actual_selling.size():
				item.load_data(Inventory.actual_selling[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.actual_selling.size():
				item.load_data(Inventory.actual_selling[inventory_index])
		
		
				
	if Inventory.current_ui_type == "display":
		$TextureRect.hide()
		$PanelContainer2.hide()
		if Inventory.display_item:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.display_item.size():
				item.load_data(Inventory.display_item[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.display_item.size():
				item.load_data(Inventory.display_item[inventory_index])
	else:
		$TextureRect.show()
		$PanelContainer2.show()
		
		
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
	ShippingHandler.shipping_list.append([item.get_data(), Global.time_mins])
	Global.create_mail.emit()
	var current_item_data = item.get_data()
	var inventory_index = Inventory.market_items[market_type].find(current_item_data)
	Inventory.market_items[market_type].pop_at(inventory_index)
	
	queue_free()


func _on_take_button_mouse_entered() -> void:
	item.button_enter()


func _on_take_button_mouse_exited() -> void:
	item.button_exit()


func _on_take_button_pressed() -> void:
	if is_parcel:
		if Inventory.player_inventory.size() <= 1:
			ShippingHandler.shipping_value -= item.shippingValue
			var current_item_data = item.get_data()
			var trimmed_list = []
			for item in ShippingHandler.delivered_list:
				trimmed_list.append(item[0])
			inventory_index = trimmed_list.find(current_item_data)
			Inventory.transfer_item(trimmed_list,
			Inventory.player_inventory, inventory_index)
			ShippingHandler.delivered_list.remove_at(inventory_index)
			if ShippingHandler.delivered_list.size() == 0:
				ShippingHandler.shipping_value = 0
			get_tree().reload_current_scene()
		else:
			print("Cannot carry any more items!")
	else:
		if Inventory.player_inventory.size() <= 1:
			var current_item_data = item.get_data()
			inventory_index = Inventory.wardrobe_inventory.find(current_item_data)
			Inventory.transfer_item(Inventory.wardrobe_inventory,
			Inventory.player_inventory, inventory_index)
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
		if Inventory.shelf_inventory.any(func(d): return d.has("type") and d["type"] == "cd_player") and item.type == "cd_player":
			print("cannot place duplacate items on shelf!")
		else:
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
	if item.type == "cd_player":
		get_tree().change_scene_to_file("res://scenes/cd_player.tscn")
	elif item.type == "camera":
		Global.camera_quality = item.condition
		get_tree().change_scene_to_file("res://scenes/camera.tscn")


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
		


func _on_eject_pressed() -> void:
	if Inventory.player_inventory.size() < 2:
		AudioManager.music_player.bus = "Master"
		AudioManager.eject()
		Inventory.transfer_item(Inventory.cd_inventory,
		Inventory.player_inventory, 0)
		get_tree().reload_current_scene()
		Global.now_playing = ""
	else:
		print("Player Inventory full!")


func _on_upload_button_button_down() -> void:
	item.button_enter()


func _on_upload_button_button_up() -> void:
	item.button_exit()


func _on_upload_button_pressed() -> void:
	Inventory.display_item = []
	Inventory.display_item.append(item.get_data())
	page_requested.emit("Selling")
	
func load_data(data):
	item.load_data(data)	

func get_data():
	return item.get_data()
