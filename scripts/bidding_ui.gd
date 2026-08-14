extends Control
 
@onready var price_display = $last_bid/bid_price
@onready var bid_contents = $price/Price
@onready var last_bidder = $last_bid/last_bid
@onready var time_left = $Time_left
@onready var item_name = $item_name
@onready var item_container = $item_container
var item_index = 0
var text = ""
func _ready() -> void:
	var packed = preload("res://scenes/item_ui.tscn")
	var storage_ui = packed.instantiate()
	storage_ui.inventory_index = item_index
	item_container.add_child(storage_ui)
 
	if item_index >= 0 and item_index < Inventory.bidding_items.size():
		var data = Inventory.bidding_items[item_index]
		item_name.text = name_generator(data)
		
	var details = Inventory.bidding_details[item_index]
	last_bidder.text = str(details["bidder_name"])
	price_display.text = str(details["bid_amount"])
	_update_time_left()
	if Global.bidding_index_selected == item_index:
		bid_contents.text = Global.buffer_text
		bid_contents.grab_focus()

# Refreshes just the countdown label instead of rebuilding the whole card,
# so this can run every frame without ever disturbing focus/input.
func _update_time_left() -> void:
	if item_index < 0 or item_index >= Inventory.bidding_details.size():
		return
	var details = Inventory.bidding_details[item_index]
	if not details.has("bid_end"):
		return
	var left = int(details["bid_end"]) - Global.time_mins
	left = max(left, 0)
	var days = floor(left/1440)
	var hours = floor(left/60) % 24

	if days > 0:
		time_left.text = str(days) + "D " + str(hours) + "H " + str(left%60) + "M left"
	else:
		time_left.text = str(hours) + "H " + str(left%60) + "M left"
	
	
func _process(_delta) -> void:
	_update_time_left()
		
func name_generator(data) -> String:
	var brand_print = ""
	var display_color = data["color1"]
	var display_color2 = data["color2"]
	
	var display_type = data["type"]
	var brand = data["brand"]
	var type = data["type"]
	
	if brand != "none":
		brand_print = brand.capitalize() + " "
	elif brand == "none":
		display_color = display_color.capitalize()
	if type == "cd_player":
		display_type = "CD Player"
	elif type == "puzzle_cube":
		display_type = "Puzzle Cube"
		display_color = ""
	elif type == "spud_poster":
		display_type = "Spud Poster"
		display_color = ""
	elif type == "potion_poster":
		display_type = "Potion Poster"
		display_color = ""
	elif type == "beh_enclosed_shirt":
		display_type = "BEH Enclosed shirt"
		display_color = ""
	elif type == "the_big_mint":
		display_type = "The Big Mint CD"
		display_color = ""
	elif type == "smooth_jazz_1":
		display_type = "Smooth Jazz Vol.1 CD"
		display_color = ""
	elif type == "three_jelly":
		display_type = "Three Jelly CD"
		display_color = ""
	elif type == "evil_pulsation":
		display_type = "Evil Pulsation CD"
		display_color = ""
	elif type == "jungle":
		display_type = "Jungle CD"
		display_color = ""
	elif type == "conceal_shoes":
		display_type = "shoes"
	elif type == "gold_ring":
		display_color = ""
		display_type = "Gold Ring"
	
	if data["overlay_animation"] == "ele_minimalistic_white" or data["overlay_animation"] == "ele_minimalistic_black":
		brand_print = "elemental minimalistic "
	
	if display_color2 != "" and display_color != "" and data["pattern_type"] != "none":
		return brand_print + display_color + " & " + display_color2.capitalize() + " " +  data["pattern_type"] + " " + display_type + "."
	elif display_color2 != "" and display_color != "":
		return brand_print + display_color + " & " + display_color2.capitalize() + " " + display_type + "."
	else:
		return brand_print + display_color + " " + display_type + "."

func _on_button_pressed() -> void:
	var details = Inventory.bidding_details[item_index]
	var prev_price = details["bid_amount"]
	var price_written:float = 0
	if bid_contents.text.is_valid_float():
		price_written = snapped(bid_contents.text.to_float(),0.01)
	if not bid_contents.text.is_valid_float():
		print("Price is not valid (do not include $).")
	elif price_written < 1:
		print("Price must be at least $1.")
	elif price_written >= 10000:
		print("Price must be under $10,000.")
	elif price_written > Global.money:
		print("You do not have enough money to buy this!")
	elif prev_price + Inventory.calculate_minimum_raise(prev_price) > price_written:
		print("Price less than minimun raise!" + "(" + str(Inventory.calculate_minimum_raise(prev_price)) + ")")
	else:
		details["bidder_name"] = "You"
		details["bid_amount"] = price_written
		details["bid_time"] = Global.time_mins
		bid_contents.text = ""
		price_display.text = str(price_written)
		var last_bidder_var = last_bidder.text
		last_bidder.text = "You"

		var bidders = Inventory.bidders
		if last_bidder_var != "You":
			for i in range(bidders.size() - 1, -1, -1):
				if bidders[i]["id"] == item_index:
					bidders.remove_at(i)
					break

		Inventory.bid_done.emit()


func _on_price_text_changed(new_text: String) -> void:
	Global.buffer_text = new_text
	Global.bidding_index_selected = item_index
	

func _on_panel_container_mouse_entered() -> void:
	if item_container.get_child_count() == 1:
		var item_ui = item_container.get_child(0)
		item_ui.display_thing()
