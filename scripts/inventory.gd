extends Node

var current_ui_type = ""
var current_market_type = "All"
var player_inventory: Array = []
var wardrobe_inventory: Array = []
var shelf_inventory: Array = []
var cd_inventory: Array = []
var display_item: Array = []
var actual_selling: Array = []
var player_selling: Array = []
var sold_items: Array = []
var actual_sold: Array = []
var display_poster: Array = []
var buyers: Array = []

# bidding lists
var bidding_items = []
var bidding_details = [{},{},{}]
var bidders: Array = []

var item_id: int = 0
var sell_id: int = 0
var market_items: Dictionary = {}
var buyer_types = ["cheap","normal","stingy"]
# global signal
signal inventories_changed
signal item_sold
signal bid_done

func transfer_item(from_array: Array, to_array: Array, from_index: int) -> bool:
	if from_index < 0 or from_index >= from_array.size() or from_array[from_index] == null:
		return false
		
	var item_to_move = from_array[from_index]
	to_array.append(item_to_move)
	from_array.pop_at(from_index)
	
	inventories_changed.emit()
	return true

func create_buyers(amount,id,listing_sell_id):
	for i in (amount-1):
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		rng.randomize()
		var current_minute = Global.time_mins
		var buyer_type = buyer_types.pick_random()
		var minutes_after = rng.randi_range(0,1440)
		var min_to_buy = current_minute + minutes_after
		var buyer_name = Global.name_generator()
		var buyer_dict: Dictionary = {
			"id": id,
			"buyer_type":buyer_type,
			"min_to_buy":min_to_buy,
			"listing_sell_id": listing_sell_id,
			"buyer_name": buyer_name
		}
		buyers.append(buyer_dict)
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var current_minute = Global.time_mins
	var buyer_type = buyer_types.pick_random()
	var min_to_buy = current_minute + 1440
	var buyer_name = Global.name_generator()
	var buyer_dict: Dictionary = {
			"id": id,
			"buyer_type":buyer_type,
			"min_to_buy":min_to_buy,
			"listing_sell_id": listing_sell_id,
			"buyer_name": buyer_name
		}
	buyers.append(buyer_dict)
		
func _ready() -> void:
	#player_inventory.append({ "ID": -1, "type": "tshirt", "number": 8, "color1": "cyan", "color2": "orange", "price": 1.5, "shippingTime": 1.0, "shippingValue": 1, "condition": "Poor", "condition_price_mult": 0.4, "brand": "none", "brandmult": 1, "selected_brand": "none", "genre": "none", "cd": false, "rarity": "common", "logo_animation": &"none", "default_price": 2.5, "overlay_animation": "none", "pattern_type": "polka-dot", "pattern_mult": 1.5, "pattern_index": 9 })
	pass
	
func _process(_delta) -> void:
	var buyers_to_remove: Array = []

	for i in actual_selling:
		var listing_sell_id = i["listing_sell_id"]
		var item_id = i["ID"]
		var buyer_count = 0

		for j in buyers:
			if j["listing_sell_id"] == listing_sell_id:
				buyer_count += 1
				if Global.time_mins >= int(j["min_to_buy"]):
					check_buy_items(j, item_id)
					buyers_to_remove.append(j)

		if buyer_count == 0:
			create_buyers(10, item_id, listing_sell_id)

	for j in buyers_to_remove:
		buyers.erase(j)
		
	var bidders_to_remove: Array = []
	var counter = 0
	for i in bidders:
		if Global.time_mins >= i["min_to_buy"]:
			bidder_raise(i)
			bidders_to_remove.append(i)

	for k in bidders_to_remove:
		bidders.erase(k)
	
	for i in range(bidding_details.size()):
		var details = bidding_details[i]
		if details.has("bid_end") and Global.time_mins >= int(details["bid_end"]):
			resolve_bid(i)
			
func get_buy_probability_sigmoid(price: float, base_price: float) -> float:
	if base_price <= 0.0:
		return 1.0
	var x: float = price - base_price
	var scale_factor: float = base_price / 4.0
	var exponent: float = x / scale_factor
	return clamp(2.0 / (1.0 + exp(exponent)),10**(-log(price)/log(10)),10) # caps at 10x more likely to buy, min is dependent on the price you give, using logorithms.
					
func check_buy_items(buyer,id):
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	
	var odds: float = 0.15 # can change
	var trust: float = 1.0
	var found_index = -1
	for i in range(actual_selling.size()):
		if actual_selling[i].get("ID") == id:
			found_index = i	
			break
	
	var actual_dict = actual_selling[found_index]
	var player_dict = player_selling[found_index]
	#print(actual_dict,player_dict)
	var worn_words = ["worn","used","damaged","poor condition"]
	var new_words = ["new","mint","minted","clean","good condition","great condition","excellent","like new"]
	if player_dict["type"].to_lower() != actual_dict["type"].to_lower():
		trust -= 0.3
	if player_dict["color1"].to_lower() != actual_dict["color1"].to_lower() and player_dict["color1"].to_lower() != actual_dict["color2"].to_lower():
		trust -= 0.15
	if player_dict["color2"].to_lower() == actual_dict["color2"].to_lower() or  player_dict["color2"].to_lower() != actual_dict["color1"].to_lower():
		trust += 0.15
	if player_dict["brand"].to_lower() != actual_dict["brand"].to_lower():
		trust -= 0.15
	if player_dict["name"].to_lower().contains(actual_dict["type"].to_lower()):
		trust += 0.1
	if player_dict["name"].to_lower().contains(actual_dict["pattern_type"].to_lower()) and actual_dict["pattern_type"].to_lower() != "none":
		trust += 0.1
	
	for word in worn_words:
		if player_dict["name"].to_lower().contains(word):
			if player_dict["condition"].to_lower() == "poor" or player_dict["condition"].to_lower() == "satisfactory":	
				trust += 0.1
				break
	for word in new_words:
		if player_dict["name"].to_lower().contains(word):
			if player_dict["condition"].to_lower() == "excellent" or player_dict["condition"].to_lower() == "minted":	
				trust += 0.1
				break
				
	var dupes = 0
	for i in range(actual_selling.size()):
		if actual_dict == actual_selling[i]:
			dupes += 1
	
	if dupes > 1:
		trust /= (dupes ** 0.7)
		
	var price_mult = 1
	var price_affect_odds = 1
	var price_given = player_dict["price"]
	var default_price = actual_dict["default_price"]
	var condition = player_dict["condition"]
	if condition == "Poor":
		price_mult = 0.4
	elif condition == "Satisfactory":
		price_mult = 0.6
	elif condition == "Good":
		price_mult = 0.8
	elif condition == "Great":
		price_mult = 0.9
	elif condition == "Minted":
		price_mult = 1.05
	else:
		price_mult = 1.0
	
	var brandmult =1 
	var pattern_mult = 1
	if actual_dict["brandmult"]:
		brandmult = actual_dict["brandmult"]
	if actual_dict["pattern_mult"]:
		pattern_mult = actual_dict["pattern_mult"]

	default_price = default_price* price_mult * brandmult * pattern_mult
	if buyer["buyer_type"] == "stingy":
		default_price *= 0.8
	elif buyer["buyer_type"] == "leniant":
		default_price *= 1.2
	price_affect_odds = get_buy_probability_sigmoid(price_given,default_price)
	odds = 0.15 * trust * price_affect_odds	
	var numbar = rng.randf()
	#print(odds, " ", numbar)
	if odds >= numbar:
		for j in buyers:
			if buyer["listing_sell_id"] == j["listing_sell_id"]:
				buyers.erase(j)
		
		
		found_index = -1
		for i in range(actual_selling.size()):
			if actual_selling[i].get("ID") == id:
				found_index = i	
				break
		Global.money += player_selling[found_index]["price"]
		transfer_item(actual_selling,actual_sold,found_index)
		player_selling[found_index]["buyer_name"] = buyer["buyer_name"]	
		transfer_item(player_selling,sold_items,found_index)
		#print(found_index, actual_selling,actual_sold)
		#print(found_index, player_selling,sold_items)
		item_sold.emit()
		Global.xp += 200

func create_bidding_details(index):
	var bidding = bidding_items[index]	
	var rarity = bidding["rarity"]
	var condition = bidding["condition"]
	var price_mult = 1
	if condition == "Poor":
		price_mult = 0.4
	elif condition == "Satisfactory":
		price_mult = 0.6
	elif condition == "Good":
		price_mult = 0.8
	elif condition == "Great":
		price_mult = 0.9
	elif condition == "Minted":
		price_mult = 1.05
	else:
		price_mult = 1.0
	
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	
	var days_to_bid = rng.randf_range(1,2)
	var raise_attempts = round(days_to_bid * 12)
	if rarity == "uncommon":
		days_to_bid += 1
		raise_attempts = round(days_to_bid * 10 * 1.1)
	elif rarity == "rare":
		days_to_bid += 2
		raise_attempts = round(days_to_bid * 10 * 1.2)
	elif rarity == "epic":
		days_to_bid += 3
		raise_attempts = round(days_to_bid * 10 * 1.5)
	elif rarity == "legendary":
		days_to_bid += 4
		raise_attempts = round(days_to_bid * 10 * 2)
	
	var brandmult = 1 
	var pattern_mult = 1
	if bidding["brandmult"]:
		brandmult = bidding["brandmult"]
	if bidding["pattern_mult"]:
		pattern_mult = bidding["pattern_mult"]
	
	var default_price = bidding["default_price"]
	default_price = default_price * price_mult * brandmult * pattern_mult
	var initial_price = max(snapped(default_price / rng.randf_range(2,5),0.5),1.00)
	var competition_num = randi_range(round(days_to_bid*1.2),round(days_to_bid*2))
	var bidder_names = []
	for i in competition_num:
		var name = Global.name_generator()
		bidder_names.append(name)
		
	var initial_bid = rng.randi_range(1,2)
	if initial_bid == 1:
		bidding_details[index] = {
			"bidder_name": bidder_names.pick_random(),
			"bid_time": Global.time_mins - rng.randi_range(1,600),
			"bid_amount": initial_price + calculate_minimum_raise(initial_price),
			"bid_end": Global.time_mins + round(days_to_bid*1440),
			"bid_begin": Global.time_mins
		}
	else:
		bidding_details[index] = {
			"bidder_name": "No Bidder",
			"bid_time": Global.time_mins,
			"bid_amount": initial_price,
			"bid_end": Global.time_mins + round(days_to_bid*1440),
			"bid_begin": Global.time_mins
		}
	#print(bidder_names)
	generate_bidders(raise_attempts, bidder_names,Global.time_mins + round(days_to_bid*1440), index)

func generate_bidders(num,names,end, index):
	for i in (num):
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		rng.randomize()
		var current_minute = Global.time_mins
		var buyer_type = buyer_types.pick_random()
		var minutes_after = rng.randi_range(0,end)
		var min_to_buy = current_minute + minutes_after
		var name = names.pick_random()
		var buyer_dict: Dictionary = {
			"id": index,
			"min_to_buy":min_to_buy,
			"buyer_name": name,
			"bid_end": end
		}
		bidders.append(buyer_dict)
	
func bidder_raise(bidder):
	var index = bidder["id"]
	var details = bidding_details[bidder["id"]]
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var odds: float = 0.25 # can change
	var bidding = bidding_items[bidder["id"]]
	var brandmult = 1 
	var pattern_mult = 1
	if bidding["brandmult"]:
		brandmult = bidding["brandmult"]
	if bidding["pattern_mult"]:
		pattern_mult = bidding["pattern_mult"]
	
	var default_price = bidding["default_price"]
	var condition = bidding["condition"]
	
	var price_mult = 1
	if condition == "Poor":
		price_mult = 0.4
	elif condition == "Satisfactory":
		price_mult = 0.6
	elif condition == "Good":
		price_mult = 0.8
	elif condition == "Great":
		price_mult = 0.9
	elif condition == "Minted":
		price_mult = 1.05
	else:
		price_mult = 1.0
	
	default_price = default_price * price_mult * brandmult * pattern_mult
	var current_price = details["bid_amount"]
	var price_affect_odds = get_buy_probability_sigmoid(current_price,default_price)
	var total_time = details["bid_end"] - details["bid_begin"]
	var time_in = Global.time_mins - details["bid_begin"]
	var decimal_in = max(0.3,time_in/total_time)
	odds = 0.2 * decimal_in*2 * price_affect_odds	
	
	var numbar = rng.randf()
	#print(odds, " ", numbar)
	if odds >= numbar:
		var raise_amount = calculate_minimum_raise(current_price)
		current_price += raise_amount * rng.randi_range(1,4)
		details["bidder_name"] = bidder["buyer_name"]
		details["bid_amount"] = current_price
		details["bid_time"] = Global.time_mins
		#print(details)
		bid_done.emit()
		
func calculate_minimum_raise(price):
	if price <= 5:
		return 0.25
	elif price <= 20:
		return 0.5
	elif price <= 50:
		return 1
	elif price <= 100:
		return 2
	else:
		return 5

func resolve_bid(index: int) -> void:
	var details = bidding_details[index]

	if details["bidder_name"] == "You":
		Global.money -= details["bid_amount"]
		ShippingHandler.shipping_list.append([bidding_items[index], Global.time_mins])
		Global.create_mail.emit()
	
	for i in range(bidders.size() - 1, -1, -1):
		if bidders[i]["id"] == index:
			bidders.remove_at(i)

	var packed = preload("res://scenes/item_ui.tscn")
	var item_ui = packed.instantiate()
	add_child(item_ui)
	item_ui.get_node("item").initialize_item("Bidding")
	bidding_items[index] = item_ui.get_data()
	create_bidding_details(index)
	item_ui.queue_free()

	bid_done.emit()
	Global.xp += 100
