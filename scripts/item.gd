extends Node2D

var colours: Array = ["white","yellow", "red", "green", "blue", "black", "purple", "pink", "cyan", "orange"]
var trouser_colours: Array = ["black", "white", "grey", "blue", "green"]
var common_items: Array = ["tshirt","socks","trousers","shorts", "shoes"]
var uncommon_items: Array = ["cd_player", "puzzle_cube"]
var items_with_regular_animation = ["cd_player", "puzzle_cube"]
var brands: Array = ["none", "elemental"]
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
var selected_brand = "none"
var counter: int = 0
var rarities = {
	"common": 1000,
	"uncommon": 300
}
var rarity = "common"
signal rarity_ui(item_rarity: String)

@onready var tshirt_sprite: AnimatedSprite2D = $TextureButton/tshirt
@onready var socks_sprite: AnimatedSprite2D = $TextureButton/socks
@onready var trouser_sprite: AnimatedSprite2D = $TextureButton/trousers
@onready var shorts_sprite: AnimatedSprite2D = $TextureButton/shorts
@onready var shoes_sprite: AnimatedSprite2D = $TextureButton/shoes
@onready var cd_player_sprite: AnimatedSprite2D = $TextureButton/cd_player
@onready var details_ui = get_node("/root/MainUI/Market/VBoxContainer/Sections/Product_Details")
@onready var tshirt_logo: AnimatedSprite2D = $TextureButton/tshirt/logo
@onready var rubiks_cube_sprite: AnimatedSprite2D = $TextureButton/puzzle_cube

func initialize_item():
	rng.randomize()
	rarity = get_rarity()
	if rarity == "common":
		type = common_items[rng.randi_range(0, common_items.size() - 1)]
	elif rarity == "uncommon":
		type = uncommon_items[rng.randi_range(0, uncommon_items.size() - 1)]
		
	generate_parameters(type)
	set_item_type(type)
	if type == "tshirt":
		logo_calculator(color)
		switch_shirt(tshirt_sprite, number);
		sprite_image = tshirt_sprite
	elif type == "socks":
		switch_shirt(socks_sprite, number);
		sprite_image = socks_sprite
	elif type == "trousers":
		switch_shirt(trouser_sprite, number)
		sprite_image = trouser_sprite
	elif type == "shorts":
		switch_shirt(shorts_sprite, number)
		sprite_image = shorts_sprite
	elif type == "shoes":
		switch_shirt(shoes_sprite, number)
		sprite_image = shoes_sprite
		selected_brand = "elemental"
		brand = "ele_shoes"
		color = "grey"
	elif type == "cd_player":
		switch_shirt(cd_player_sprite, number)
		sprite_image = cd_player_sprite
		selected_brand = "C.O.M.A"
		brand = "C.O.M.A"
		color = "grey"
	elif type == "puzzle_cube":
		switch_shirt(rubiks_cube_sprite, number)
		sprite_image = rubiks_cube_sprite
		color = "multi"
	
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
	for child in get_tree().get_nodes_in_group("clothes"):
		if child.owner == self:
			child.visible = (child.name == item_type)
	
func _on_texture_button_mouse_entered():
	details_ui.display_logo(tshirt_logo, brand,0)
	details_ui.display_product_info(sprite_image, type, color, price, shippingTime, condition, number, selected_brand)
	if type in items_with_regular_animation:
		counter = 0
	$FrameTimer.start()

func _on_texture_button_mouse_exited():
	details_ui.display_logo(tshirt_logo, brand,0)
	details_ui.display_product_info(sprite_image, type, color, price, shippingTime, condition, number, selected_brand)
	$FrameTimer.stop()
	for child in get_tree().get_nodes_in_group("clothes"):
		child.stop()
		if child.owner == self:
			child.frame = 0
			tshirt_logo.frame = 0

func _on_frame_timer_timeout():
	for child in get_tree().get_nodes_in_group("clothes"):
		details_ui.display_product_info(sprite_image, type, color, price, shippingTime, condition, number, selected_brand)
		if child.visible and child is AnimatedSprite2D and child.owner == self and !(type in items_with_regular_animation):
			var max_frames = child.sprite_frames.get_frame_count("default")
			var new_frame = rng.randi_range(0, max_frames - 1)
			while new_frame == child.frame and max_frames > 1:
				new_frame = rng.randi_range(0, max_frames - 1)
			child.frame = new_frame
			tshirt_logo.frame = new_frame
			details_ui.display_logo(tshirt_logo, brand,new_frame)
		elif child.visible and child is AnimatedSprite2D and child.owner == self and type in items_with_regular_animation:
			child.play("default")


func button_enter():
	details_ui.display_logo(tshirt_logo, brand,0)
	details_ui.display_product_info(sprite_image, type, color, price, shippingTime, condition, number, selected_brand)
	$FrameTimer.start()
	
func button_exit():
	details_ui.display_logo(tshirt_logo, brand,0)
	details_ui.display_product_info(sprite_image, type, color, price, shippingTime, condition, number, selected_brand)
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

func switch_shirt(sprite, num):
	set_node_palette(sprite, num)

func set_node_palette(target_sprite: AnimatedSprite2D, num):
	if target_sprite and target_sprite.material is ShaderMaterial:
		target_sprite.set_instance_shader_parameter("palette_index", num)
