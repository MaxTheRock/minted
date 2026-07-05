extends Node2D

var colours: Array = ["white","yellow", "red", "green", "blue", "black", "purple", "pink", "cyan", "orange"]
var trouser_colours: Array = ["white", "black", "grey", "blue", "green"]
var common_items: Array = ["tshirt","socks","trousers","shorts", "shoes","boxers", "smooth_jazz_1"]
var uncommon_items: Array = ["cd_player", "puzzle_cube", "spud_poster","potion_poster", "camera"]
var rare_items: Array = ["the_big_mint"]
var epic_items: Array = ["beh_enclosed_shirt"]
var items_with_regular_animation = ["cd_player", "puzzle_cube", "camera"]
var items_that_spin = ["the_big_mint", "smooth_jazz_1"]
var cds = ["the_big_mint", "smooth_jazz_1"]
var brands: Array = ["none", "elemental"]
# Categories
var clothes: Array = ["tshirt", "socks", "trousers", "shorts", "shoes", "beh_enclosed_shirt","boxers"]
var toys: Array = ["puzzle_cube"]
var home: Array = ["spud_poster","potion_poster"]
var electronics: Array = ["cd_player", "the_big_mint", "smooth_jazz_1", "camera"]
var books_and_media: Array = ["spud_poster","potion_poster", "the_big_mint", "smooth_jazz_1"]
var collectables: Array = ["puzzle_cube", "spud_poster", "beh_enclosed_shirt"]
var sports: Array = ["beh_enclosed_shirt"]
# ---------------------------------------------
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var number: int = 0
var color: String = ""
var shippingTime: float = 0
var conditions = ["Poor", "Satisfactory", "Good", "Great", "Excellent", "Minted"]
var condition = ""
var condition_price_mult = 1
var price = 0
var type = ""
var last_frame: int = 0
var chosen_frame: int = 0
var sprite_image: AnimatedSprite2D
var brandmult = 1
var brand = "none"
var genre = "none"
var cd: bool = false
var selected_brand = "none"
var counter: int = 0
var hovering = false
var rarities = {
	"common": 1000,
	"uncommon": 300,
	"rare": 100,
	"epic": 20,
}
var rarity = "common"
signal rarity_ui(item_rarity: String)
var socks_shader = preload("res://shaders/color_swap_sock.gdshader")
var tshirt_shader = preload("res://shaders/color_swap_t_shirt.gdshader")
var socks_texture = preload("res://shaders/socks_colours.png")
var tshirt_texture = preload("res://shaders/tshirt_colours.png")
var trousers_texture = preload("res://shaders/trousers_colours.png")
var shorts_texture = preload("res://shaders/shorts_colours.png")
var boxers_texture = preload("res://shaders/boxers_colours.png")

@onready var sprites := {
	"tshirt": $TextureButton/tshirt,
	"socks": $TextureButton/socks,
	"trousers": $TextureButton/trousers,
	"shorts": $TextureButton/shorts,
	"shoes": $TextureButton/shoes,
	"cd_player": $TextureButton/cd_player,
	"puzzle_cube": $TextureButton/puzzle_cube,
	"spud_poster": $TextureButton/spud_poster,
	"beh_enclosed_shirt": $TextureButton/beh_enclosed_shirt,
	"potion_poster": $TextureButton/potion_poster,
	"boxers": $TextureButton/boxers,
	"the_big_mint": $TextureButton/the_big_mint,
	"smooth_jazz_1": $TextureButton/smooth_jazz_1,
	"camera": $TextureButton/camera,
}

@onready var details_ui = get_node_or_null("/root/MainUI/Market/VBoxContainer/Sections/Product_Details")
@onready var tshirt_logo: AnimatedSprite2D = $TextureButton/tshirt/logo

func _process(delta):
	if !hovering:
		for child in get_tree().get_nodes_in_group("clothes"):
			if child.owner == self:
				child.rotation_degrees = 0
		return

	if !(type in items_that_spin):
		return

	for child in get_tree().get_nodes_in_group("clothes"):
		if child.visible and child is AnimatedSprite2D and child.owner == self:
			child.rotation_degrees += 160 * delta

func initialize_item(category := "All"):
	brandmult = 1
	brand = "none"
	selected_brand = "none"
	genre = "none"
	cd = false
	rng.randomize()
	match category:
		"Clothes":
			type = clothes.pick_random()
		"Toys":
			type = toys.pick_random()
		"Home":
			type = home.pick_random()
		"Electronics":
			type = electronics.pick_random()
		"BooksMedia":
			type = books_and_media.pick_random()
		"Collectables":
			type = collectables.pick_random()
		"Sports":
			type = sports.pick_random()
		_:
			type = get_random_item()
	generate_parameters(type)
	set_item_type(type)
	
	if type in common_items:
		rarity = "common"
	elif type in uncommon_items:
		rarity = "uncommon"
	elif type in rare_items:
		rarity = "rare"
	elif type in epic_items:
		rarity = "epic"
	
	if sprites.has(type):
		var sprite = sprites[type]
		set_node_palette(sprite, number)
		sprite_image = sprite
	
	if type == "shoes":
		selected_brand = "elemental"
		brand = "ele_shoes"
		color = "grey"
	elif type == "cd_player":
		selected_brand = "C.O.M.A"
		brand = "C.O.M.A"
		color = "grey"
	elif type == "puzzle_cube":
		color = "multi"
		brand = "none"
	elif type == "spud_poster":
		color = "brown"
	elif type == "beh_enclosed_shirt":
		color = "turquoise & blue"
	elif type == "potion_poster":
		color = "purple & black"
	elif type == "the_big_mint":
		color = "black & green"
	elif type == "smooth_jazz_1":
		color = "cream"
	elif type == "camera":
		selected_brand = "C.O.M.A"
		brand = "C.O.M.A"
		color = "grey"
	emit_signal("rarity_ui", rarity)

func get_random_item() -> String:
	var total_weight := 0

	if common_items.size() > 0:
		total_weight += rarities["common"]
	if uncommon_items.size() > 0:
		total_weight += rarities["uncommon"]
	if rare_items.size() > 0:
		total_weight += rarities["rare"]
	if epic_items.size() > 0:
		total_weight += rarities["epic"]

	var roll := rng.randi_range(1, total_weight)

	if common_items.size() > 0:
		if roll <= rarities["common"]:
			return common_items.pick_random()
		roll -= rarities["common"]

	if uncommon_items.size() > 0:
		if roll <= rarities["uncommon"]:
			return uncommon_items.pick_random()
		roll -= rarities["uncommon"]

	if rare_items.size() > 0:
		if roll <= rarities["rare"]:
			return rare_items.pick_random()
		roll -= rarities["rare"]

	return epic_items.pick_random()
	
func get_rarity():
	rng.randomize()
	var weighted_sum = 0
	for n in rarities:
		weighted_sum += rarities[n]
	
	var rarity_selected = rng.randi_range(0,weighted_sum)
	for n in rarities:
		if rarity_selected <= rarities[n]:
			return n
		else:
			rarity_selected -= rarities[n]
			
				
func logo_calculator(color_of_shirt: String) -> void:
	selected_brand = brands.pick_random()
	if selected_brand == "elemental":
		brandmult = 1.5
		var rnd_outcome = [1,2].pick_random()
		if color_of_shirt == "black" and rnd_outcome == 1:
			brand = "ele_minimalistic_black"
			tshirt_logo.animation = "ele_minimalistic_white"
		elif color_of_shirt == "white" and rnd_outcome == 1:
			tshirt_logo.animation = "ele_minimalistic_black"
			brand = "ele_minimalistic_white"
		else:
			tshirt_logo.animation = "ele_regular"
			brand = "ele_regular"
	else:
		tshirt_logo.animation = "none"

	tshirt_logo.frame = 0
	tshirt_logo.stop()
	details_ui.stop_logo()

func set_item_type(item_type: String) -> void:
	for sprite in sprites.values():
		sprite.hide()
	if sprites.has(item_type):
		sprites[item_type].show()
	
func _on_texture_button_mouse_entered():
	hovering = true
	if Global.inWardrobe == false and Global.inShelf == false:
		details_ui.display_logo(tshirt_logo, brand,0)
	
	if type in items_with_regular_animation:
		counter = 0
	$FrameTimer.start()

func _on_texture_button_mouse_exited():
	hovering = false
	if Global.inWardrobe == false and Global.inShelf == false:
		details_ui.display_logo(tshirt_logo, brand,0)
		details_ui.display_product_info(sprite_image, type, color, price, shippingTime, condition, number, selected_brand, cd, genre)
	$FrameTimer.stop()
	for child in get_tree().get_nodes_in_group("clothes"):
		child.stop()
		if child.owner == self:
			child.frame = 0
			tshirt_logo.frame = 0

func _on_frame_timer_timeout():
	for child in get_tree().get_nodes_in_group("clothes"):
		if Global.inWardrobe == false and Global.inShelf == false:
			details_ui.display_product_info(sprite_image, type, color, price, shippingTime, condition, number, selected_brand, cd, genre)
		if child.visible and child is AnimatedSprite2D and child.owner == self and !(type in items_with_regular_animation):
			var max_frames = child.sprite_frames.get_frame_count("default")
			var new_frame = rng.randi_range(0, max_frames - 1)
			while new_frame == child.frame and max_frames > 1:
				new_frame = rng.randi_range(0, max_frames - 1)
			child.frame = new_frame
			tshirt_logo.frame = new_frame
			if Global.inWardrobe == false and Global.inShelf == false:
				details_ui.display_logo(tshirt_logo, brand,new_frame)
		elif child.visible and child is AnimatedSprite2D and child.owner == self and type in items_with_regular_animation:
			child.play("default")

func button_enter():
	if Global.inWardrobe == false and Global.inShelf == false:
		details_ui.display_logo(tshirt_logo, brand,0)
		details_ui.display_product_info(sprite_image, type, color, price, shippingTime, condition, number, selected_brand, cd, genre)
	$FrameTimer.start()
	
func button_exit():
	if Global.inWardrobe == false and Global.inShelf == false:
		details_ui.display_logo(tshirt_logo, brand,0)
		details_ui.display_product_info(sprite_image, type, color, price, shippingTime, condition, number, selected_brand, cd, genre)
	$FrameTimer.stop()
	for child in get_tree().get_nodes_in_group("clothes"):
		if child.owner == self:
			child.frame = 0
			tshirt_logo.frame = 0
	
func generate_parameters(type):
	if type == "tshirt":
		number = rng.randi_range(0, colours.size()-1)
		color = colours[number]
		shippingTime = rng.randi_range(1, 5.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		logo_calculator(color)
		price = snapped(2.5 * condition_price_mult * rng.randf_range(0.8,1.2) * brandmult,0.01)
		
	elif type == "socks":
		number = rng.randi_range(0, colours.size()-1)
		color = colours[number]
		shippingTime = rng.randi_range(1, 5.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(1.5 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
	
	elif type == "trousers":
		number = rng.randi_range(0, trouser_colours.size()-1)
		color = trouser_colours[number]
		shippingTime = rng.randi_range(1, 5.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(4.5 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
		
	elif type == "shorts":
		number = rng.randi_range(0, trouser_colours.size()-1)
		color = trouser_colours[number]
		shippingTime = rng.randi_range(1, 5.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(3 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
	elif type == "shoes":
		number = rng.randi_range(0, colours.size()-1)
		color = colours[number]
		shippingTime = rng.randi_range(1, 5.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(15 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
	elif type == "cd_player":
		shippingTime = rng.randi_range(2, 6.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(10 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
	elif type == "puzzle_cube":
		shippingTime = rng.randi_range(1, 6.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(7 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
	elif type == "spud_poster":
		shippingTime = rng.randi_range(1, 6.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(7 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
	elif type == "beh_enclosed_shirt":
		shippingTime = rng.randi_range(3, 10.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(23 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
	elif type == "potion_poster":
		shippingTime = rng.randi_range(1, 5.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(8 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
	elif type == "boxers":
		number = rng.randi_range(0, colours.size()-1)
		color = colours[number]
		shippingTime = rng.randi_range(1, 5.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(2 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
	elif type == "the_big_mint":
		shippingTime = rng.randi_range(1, 6.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		genre = "rage"
		price = snapped(9 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
	elif type == "smooth_jazz_1":
		shippingTime = rng.randi_range(1, 6.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(7 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
		genre = "jazz"
	elif type == "camera":
		shippingTime = rng.randi_range(1, 6.0)
		condition = conditions.pick_random()
		condition_price_mult = condition_mult_calc(condition)
		price = snapped(7 * condition_price_mult * rng.randf_range(0.8,1.2),0.01)
	
	if type in cds:
		cd = true
	
	# minimum price is £1
	if price < 1:
		price = 1.00
func condition_mult_calc(condition: String) -> float:
	if condition == "Poor":
		return 0.4
	elif condition == "Satisfactory":
		return 0.6
	elif condition == "Good":
		return 0.8
	elif condition == "Great":
		return 0.9
	else:
		return 1.0

func set_node_palette(target_sprite: AnimatedSprite2D, num):
	if target_sprite.material == null:
		target_sprite.material = ShaderMaterial.new()
	if type == "socks":
		target_sprite.material.shader = socks_shader
		
		target_sprite.material.set_shader_parameter("palette_texture", socks_texture)
		target_sprite.material.set_shader_parameter("tolerance", 0.1)
		target_sprite.material.set_shader_parameter("color_count", 6)
		target_sprite.material.set_shader_parameter("palette_count", 10)
		target_sprite.set_instance_shader_parameter("palette_index", num)
		
	elif type == "tshirt":
		target_sprite.material.shader = tshirt_shader
		
		target_sprite.material.set_shader_parameter("palette_texture", tshirt_texture)
		target_sprite.material.set_shader_parameter("tolerance", 0.1)
		target_sprite.material.set_shader_parameter("color_count", 5)
		target_sprite.material.set_shader_parameter("palette_count", 10)
		target_sprite.set_instance_shader_parameter("palette_index", num)
	elif type == "shorts":
		target_sprite.material.shader = tshirt_shader
		
		target_sprite.material.set_shader_parameter("palette_texture", shorts_texture)
		target_sprite.material.set_shader_parameter("tolerance", 0.1)
		target_sprite.material.set_shader_parameter("color_count", 4)
		target_sprite.material.set_shader_parameter("palette_count", 5)
		target_sprite.set_instance_shader_parameter("palette_index", num)
	elif type == "trousers":
		target_sprite.material.shader = tshirt_shader
		
		target_sprite.material.set_shader_parameter("palette_texture", trousers_texture)
		target_sprite.material.set_shader_parameter("tolerance", 0.1)
		target_sprite.material.set_shader_parameter("color_count", 4)
		target_sprite.material.set_shader_parameter("palette_count", 5)
		target_sprite.set_instance_shader_parameter("palette_index", num)
	elif type == "boxers":
		target_sprite.material.shader = tshirt_shader
		
		target_sprite.material.set_shader_parameter("palette_texture", boxers_texture)
		target_sprite.material.set_shader_parameter("tolerance", 0.1)
		target_sprite.material.set_shader_parameter("color_count", 6)
		target_sprite.material.set_shader_parameter("palette_count", 10)
		target_sprite.set_instance_shader_parameter("palette_index", num)
	else:
		target_sprite.material.shader = null

#------ for storage
func get_data() -> Dictionary:
	return {
		"type": type,
		"number": number,
		"color": color,
		"price": price,
		"shippingTime": shippingTime,
		"condition": condition,
		"condition_price_mult": condition_price_mult,
		"brand": brand,
		"selected_brand": selected_brand,
		"genre": genre,
		"cd": cd,
		"rarity": rarity,
		"logo_animation": tshirt_logo.animation if tshirt_logo else "none",
	}

func load_data(data: Dictionary) -> void:
	type = data.get("type", "")
	number = data.get("number", 0)
	color = data.get("color", "")
	price = data.get("price", 0)
	shippingTime = data.get("shippingTime", 0)
	condition = data.get("condition", "")
	condition_price_mult = data.get("condition_price_mult", 1)
	brand = data.get("brand", "none")
	selected_brand = data.get("selected_brand", "none")
	genre = data.get("genre", "none")
	cd = data.get("cd", false)
	rarity = data.get("rarity", "common")

	set_item_type(type)

	if sprites.has(type):
		var sprite = sprites[type]
		set_node_palette(sprite, number)
		sprite_image = sprite

	if type == "tshirt" and tshirt_logo:
		tshirt_logo.animation = data.get("logo_animation", "none")
		tshirt_logo.frame = 0
		tshirt_logo.stop()

	emit_signal("rarity_ui", rarity)
