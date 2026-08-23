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
@onready var rarety_mark = $rarety_mark
@onready var condition_mark = $condition_mark
@onready var hbox_use = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/HBoxContainer/Use
@onready var hbox_remove = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/HBoxContainer/Remove
@onready var cd_use = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/cd_playing/Use
@onready var cd_eject = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/cd_playing/Eject
@onready var tooltip = $Tooltip

signal page_requested(page_name: String)
signal poster_selected(item_data: Dictionary)

var placeable_items: Array = ["cd_player", "camera"]
var market_type = ""

var inventory_index = 0
var is_parcel = false


func _ready() -> void:
	tooltip.hide()
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
		panel_container.custom_maximum_size = Vector2(150, 160)
		$PanelContainer2.hide()
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
		panel_container.custom_maximum_size = Vector2(150, 160)
		$PanelContainer2.hide()
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
		$PanelContainer2.hide()

		if Inventory.actual_selling:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.actual_selling.size():
				item.load_data(Inventory.actual_selling[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.actual_selling.size():
				item.load_data(Inventory.actual_selling[inventory_index])
	
	elif Inventory.current_ui_type == "display_sold":
		buy_button.hide()
		take_button.hide()
		place_button.hide()
		put_button.hide()
		shelf_ui_buttons.hide()
		use_button.hide()
		eject_button.hide()
		grid_container.hide()
		upload_button.hide()
		$PanelContainer2.hide()

		if Inventory.actual_sold:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.actual_sold.size():
				item.load_data(Inventory.actual_sold[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.actual_sold.size():
				item.load_data(Inventory.actual_sold[inventory_index])
				
	elif Inventory.current_ui_type == "display":
		$PanelContainer2.hide()

		if Inventory.display_item:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.display_item.size():
				item.load_data(Inventory.display_item[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.display_item.size():
				item.load_data(Inventory.display_item[inventory_index])

	elif Inventory.current_ui_type == "poster":
		buy_button.hide()
		take_button.hide()
		place_button.show()
		put_button.hide()
		eject_button.hide()
		use_button.hide()
		upload_button.hide()
		shelf_ui_buttons.hide()
		grid_container.show()

		if Inventory.player_inventory:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.player_inventory.size():
				item.load_data(Inventory.player_inventory[inventory_index])
	
	elif Inventory.current_ui_type == "display_bidding":
		buy_button.hide()
		take_button.hide()
		place_button.hide()
		put_button.hide()
		shelf_ui_buttons.hide()
		use_button.hide()
		eject_button.hide()
		grid_container.hide()
		upload_button.hide()
		panel_container.custom_maximum_size = Vector2(150, 160)
		$PanelContainer2.hide()
		
		if Inventory.bidding_items:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.bidding_items.size():
				item.load_data(Inventory.bidding_items[inventory_index])
		else:
			item.rarity_ui.connect(_rarity_ui)
			if inventory_index >= 0 and inventory_index < Inventory.bidding_items.size():
				item.load_data(Inventory.bidding_items[inventory_index])
				
	else:
		$TextureRect.show()
		$PanelContainer2.show()


func _rarity_ui(item_rarity) -> void:
	rarety_mark.play(item_rarity)
	# also added the condition but didnt really know where else to put it, so i put it here...
	condition_mark.play(item.condition.to_lower())

func _on_buy_button_mouse_entered() -> void:
	tooltip_show()
	item.button_enter()
	buy_button.modulate = Color(0.7, 0.7, 0.7, 1)

func _on_buy_button_mouse_exited() -> void:
	tooltip_hide()
	item.button_exit()
	buy_button.modulate = Color(1, 1, 1, 1)

func _on_buy_button_pressed() -> void:
	buy_button.modulate = Color(0.5, 0.5, 0.5, 1)
	if not Inventory.market_items.has(market_type):
		print("Invalid market_type:", market_type)
		return
	if Global.money < item.price:
		return
	
	Global.money -= item.price
	ShippingHandler.shipping_list.append([item.get_data(), Global.time_mins])
	Global.create_mail.emit()

	var current_item_data = item.get_data()
	print(current_item_data)
	var inventory_index = Inventory.market_items[market_type].find(current_item_data)
	Inventory.market_items[market_type].pop_at(inventory_index)

	queue_free()



func _on_take_button_mouse_entered() -> void:
	item.button_enter()
	take_button.modulate = Color(0.7, 0.7, 0.7, 1)
 
 
func _on_take_button_mouse_exited() -> void:
	item.button_exit()
	take_button.modulate = Color(1, 1, 1, 1)
 
 
func _on_take_button_pressed() -> void:
	take_button.modulate = Color(0.5, 0.5, 0.5, 1)
	if is_parcel:
		if Inventory.player_inventory.size() <= 1:
			if inventory_index < 0 or inventory_index >= ShippingHandler.delivered_list.size():
				print("Could not find parcel item to take!")
				return
 
			ShippingHandler.shipping_value -= item.shippingValue
 
			Inventory.player_inventory.append(ShippingHandler.delivered_list[inventory_index][0])
			ShippingHandler.delivered_list.remove_at(inventory_index)
			Inventory.inventories_changed.emit()
 
			if ShippingHandler.delivered_list.size() == 0:
				ShippingHandler.shipping_value = 0
 
			get_tree().reload_current_scene()
		else:
			print("Cannot carry any more items!")
	else:
		if Inventory.player_inventory.size() <= 1:
			if inventory_index < 0 or inventory_index >= Inventory.wardrobe_inventory.size():
				print("Could not find wardrobe item to take!")
				return
 
			Inventory.transfer_item(
				Inventory.wardrobe_inventory,
				Inventory.player_inventory,
				inventory_index
			)
 
			get_tree().reload_current_scene()
		else:
			print("Cannot carry any more items!")
 
 
func _on_put_button_button_down() -> void:
	item.button_enter()
 
 
func _on_put_button_button_up() -> void:
	item.button_exit()
 
 
func _on_put_button_pressed() -> void:
	put_button.modulate = Color(0.5, 0.5, 0.5, 1)
	if Inventory.wardrobe_inventory.size() <= Global.storage_capacity:
		if inventory_index < 0 or inventory_index >= Inventory.player_inventory.size():
			print("Could not find item to put away!")
			return
 
		Inventory.transfer_item(
			Inventory.player_inventory,
			Inventory.wardrobe_inventory,
			inventory_index
		)
 
		queue_free()
		get_tree().reload_current_scene()
	else:
		print("Wardrobe cannot annot carry any more items!")
 
 
func _on_place_button_button_down() -> void:
	item.button_enter()
 
 
func _on_place_button_button_up() -> void:
	item.button_exit()
 
 
func _on_place_button_pressed() -> void:
	place_button.modulate = Color(1, 1, 1, 1)
	print(Inventory.current_ui_type)
	if Inventory.current_ui_type == "poster":
		if inventory_index < 0 or inventory_index >= Inventory.player_inventory.size():
			print("Could not find item to place!")
			return
 
		Inventory.transfer_item(
				Inventory.player_inventory,
				Inventory.display_poster,
				inventory_index
			)
		poster_selected.emit(item.get_data())
		return
 
	if Inventory.shelf_inventory.size() <= 5:
		if Inventory.shelf_inventory.any(func(d): return d.has("type") and d["type"] == "cd_player") and item.type == "cd_player":
			print("cannot place duplacate items on shelf!")
		else:
			if inventory_index < 0 or inventory_index >= Inventory.player_inventory.size():
				print("Could not find item to place!")
				return
 
			Inventory.transfer_item(
				Inventory.player_inventory,
				Inventory.shelf_inventory,
				inventory_index
			)
 
			queue_free()
			get_tree().reload_current_scene()
	else:
		print("Shelf cannot annot carry any more items!")
 
 
func _on_remove_button_down() -> void:
	item.button_enter()
 
 
func _on_remove_button_up() -> void:
	item.button_exit()
 
 
func _on_remove_pressed() -> void:
	hbox_remove.modulate = Color(0.5, 0.5, 0.5, 1)
	if Inventory.player_inventory.size() <= 1:
		if inventory_index < 0 or inventory_index >= Inventory.shelf_inventory.size():
			print("Could not find shelf item to remove!")
			return
 
		Inventory.transfer_item(
			Inventory.shelf_inventory,
			Inventory.player_inventory,
			inventory_index
		)
 
		queue_free()
		get_tree().reload_current_scene()
	else:
		print("Cannot carry any more items!")
 
 
func _on_use_pressed() -> void:
	hbox_use.modulate = Color(0.5, 0.5, 0.5, 1)
	if item.type == "cd_player":
		get_tree().change_scene_to_file("res://scenes/cd_player.tscn")
	elif item.type == "camera":
		Global.camera_quality = item.condition
		get_tree().change_scene_to_file("res://scenes/camera.tscn")
 
 
func _on_use_button_pressed() -> void:
	use_button.modulate = Color(0.5, 0.5, 0.5, 1)
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
 
		if inventory_index < 0 or inventory_index >= Inventory.player_inventory.size():
			print("Could not find CD to play!")
			return
 
		Inventory.transfer_item(
			Inventory.player_inventory,
			Inventory.cd_inventory,
			inventory_index
		)
 
		queue_free()
		get_tree().reload_current_scene()
	else:
		print("there is a cd in use!")
 
 
func _on_eject_pressed() -> void:
	cd_eject.modulate = Color(0.5, 0.5, 0.5, 1)
	if Inventory.player_inventory.size() < 2:
		AudioManager.music_player.bus = "Master"
		AudioManager.eject()
 
		Inventory.transfer_item(
			Inventory.cd_inventory,
			Inventory.player_inventory,
			0
		)
 
		get_tree().reload_current_scene()
		Global.now_playing = ""
	else:
		print("Player Inventory full!")
 
 
func _on_upload_button_button_down() -> void:
	item.button_enter()
 
 
func _on_upload_button_button_up() -> void:
	item.button_exit()
 
 
func _on_upload_button_pressed() -> void:
	upload_button.modulate = Color(0.5, 0.5, 0.5, 1)
	Inventory.display_item = []
	Inventory.display_item.append(item.get_data())
	page_requested.emit("Selling")
 
 
func load_data(data):
	item.load_data(data)
 
 
func get_data():
	return item.get_data()

func create_item():
	item.initialize_item()
	get_data()

func initialize_item(catergory):
	item.initialize_item(catergory)

func display_thing():
	item.display_thing()


func _on_use_button_mouse_entered() -> void:
	use_button.modulate = Color(0.7, 0.7, 0.7, 1)
	tooltip_show()


func _on_use_button_mouse_exited() -> void:
	use_button.modulate = Color(1, 1, 1, 1)
	tooltip_hide()


func _on_put_button_mouse_entered() -> void:
	put_button.modulate = Color(0.7, 0.7, 0.7, 1)
	tooltip_show()


func _on_put_button_mouse_exited() -> void:
	put_button.modulate = Color(1, 1, 1, 1)
	tooltip_hide()


func _on_place_button_mouse_entered() -> void:
	place_button.modulate = Color(0.7, 0.7, 0.7, 1)
	tooltip_show()

func _on_upload_button_mouse_entered() -> void:
	upload_button.modulate = Color(0.7, 0.7, 0.7, 1)
	tooltip_show()

func _on_upload_button_mouse_exited() -> void:
	upload_button.modulate = Color(1, 1, 1, 1)
	tooltip_hide()


func _on_place_button_mouse_exited() -> void:
	place_button.modulate = Color(1, 1, 1, 1)
	tooltip_hide()


func _on_use_mouse_entered() -> void:
	hbox_use.modulate = Color(0.7, 0.7, 0.7, 1)
	tooltip_show()


func _on_use_mouse_exited() -> void:
	hbox_use.modulate = Color(1, 1, 1, 1)
	tooltip_hide()


func _on_remove_mouse_entered() -> void:
	hbox_remove.modulate = Color(0.7, 0.7, 0.7, 1)
	tooltip_show()


func _on_remove_mouse_exited() -> void:
	hbox_remove.modulate = Color(1, 1, 1, 1)
	tooltip_hide()


func _on_cd_use_mouse_entered() -> void:
	cd_use.modulate = Color(0.7, 0.7, 0.7, 1)
	tooltip_show()


func _on_cd_use_mouse_exited() -> void:
	cd_use.modulate = Color(1, 1, 1, 1)
	tooltip_hide()

func _on_eject_mouse_entered() -> void:
	cd_eject.modulate = Color(0.7, 0.7, 0.7, 1)
	tooltip_show()


func _on_eject_mouse_exited() -> void:
	cd_eject.modulate = Color(1, 1, 1, 1)
	tooltip_hide()

func tooltip_show():
	tooltip.show()
	self.z_index = 5
	
func tooltip_hide():
	tooltip.hide()
	self.z_index = 0
