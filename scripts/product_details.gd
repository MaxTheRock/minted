extends VBoxContainer

@onready var color_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/Color
@onready var price_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/Price
@onready var shipping_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Shipping
@onready var condition_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer5/MarginContainer/Condition
@onready var preview_image = $MarginContainer/VBoxContainer/MarginContainer/TextureRect
@onready var logo = $MarginContainer/VBoxContainer/MarginContainer/TextureRect/logo
@onready var brand_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer6/MarginContainer/Brand
@onready var product_label_name = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/Product_Name

var colours: Array = ["white","yellow", "red", "green", "blue", "black", "purple", "pink", "cyan", "orange"]
var socks_shader = preload("res://shaders/color_swap_sock.gdshader")
var tshirt_shader = preload("res://shaders/color_swap_t_shirt.gdshader")
var socks_texture = preload("res://shaders/socks_colours.png")
var tshirt_texture = preload("res://shaders/tshirt_colours.png")
var trousers_texture = preload("res://shaders/trousers_colours.png")
var shorts_texture = preload("res://shaders/shorts_colours.png")
var boxers_texture = preload("res://shaders/boxers_colours.png")

func display_product_info(sprite: AnimatedSprite2D, type, color, price, shipping, condition, color_index, brand) -> void:
	preview_image.visible = true
	if sprite:
		preview_image.texture = sprite.sprite_frames.get_frame_texture("default", sprite.frame)
	product_label_name.text = name_generator(brand, color, type, condition)
	color_label.text = "Colour: " + str(color)[0].to_upper() + str(color).substr(1)
	if str(price)[-2] == ".":
		price_label.text = "$" + str(price) + "0"
	else:
		price_label.text = "$" + str(price)
	shipping_label.text = "Shipping Time: " + str(shipping) + " days"
	condition_label.text = "Condition: " + str(condition)
	brand_label.text = "Brand: " + str(brand)[0].to_upper() + str(brand).substr(1)
	if condition == "Minted":
		condition_label.self_modulate = Color8(62, 180, 137) # mint colour
	else:
		condition_label.self_modulate = Color8(255,255,255)
		
	if preview_image.material == null:
		preview_image.material = ShaderMaterial.new()
	if type == "socks":
		preview_image.material.shader = socks_shader
		
		preview_image.material.set_shader_parameter("palette_texture", socks_texture)
		preview_image.material.set_shader_parameter("tolerance", 0.1)
		preview_image.material.set_shader_parameter("color_count", 6)
		preview_image.material.set_shader_parameter("palette_count", 10)
		preview_image.set_instance_shader_parameter("palette_index", color_index)
		
	elif type == "tshirt":
		preview_image.material.shader = tshirt_shader
		preview_image.material.set_shader_parameter("palette_texture", tshirt_texture)
		preview_image.material.set_shader_parameter("tolerance", 0.1)
		preview_image.material.set_shader_parameter("color_count", 5)
		preview_image.material.set_shader_parameter("palette_count", 10)
		preview_image.set_instance_shader_parameter("palette_index", color_index)
	elif type == "shorts":
		preview_image.material.shader = tshirt_shader
		
		preview_image.material.set_shader_parameter("palette_texture", shorts_texture)
		preview_image.material.set_shader_parameter("tolerance", 0.1)
		preview_image.material.set_shader_parameter("color_count", 4)
		preview_image.material.set_shader_parameter("palette_count", 5)
		preview_image.set_instance_shader_parameter("palette_index", color_index)
	elif type == "trousers":
		preview_image.material.shader = tshirt_shader
		
		preview_image.material.set_shader_parameter("palette_texture", trousers_texture)
		preview_image.material.set_shader_parameter("tolerance", 0.1)
		preview_image.material.set_shader_parameter("color_count", 4)
		preview_image.material.set_shader_parameter("palette_count", 5)
		preview_image.set_instance_shader_parameter("palette_index", color_index)
	
	elif type == "boxers":
		preview_image.material.shader = tshirt_shader
		
		preview_image.material.set_shader_parameter("palette_texture", boxers_texture)
		preview_image.material.set_shader_parameter("tolerance", 0.1)
		preview_image.material.set_shader_parameter("color_count", 6)
		preview_image.material.set_shader_parameter("palette_count", 10)
		preview_image.set_instance_shader_parameter("palette_index", color_index)
		
	else:
		preview_image.material.shader = null
		
func display_logo(sprite: AnimatedSprite2D, brand, frame):
	if brand == "ele_shoes":
		logo.animation = "none"
		logo.frame = 0
	else:
		logo.animation = brand
		logo.frame = frame
		
	
func stop_logo() -> void:
	logo.stop()

func on_ready() -> void:
	preview_image.visible = false

func name_generator(brand, color, type, condition) -> String:
	var brand_print = ""
	var display_color = color
	var display_type = type
	if brand != "none":
		brand_print = brand[0].to_upper() + brand.substr(1) + " "
	elif brand == "none":
		display_color = display_color[0].to_upper() + display_color.substr(1)
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
	return brand_print + display_color + " " + display_type + "."
