extends VBoxContainer

@onready var color_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/Color
@onready var price_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/Price
@onready var shipping_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Shipping
@onready var condition_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer5/MarginContainer/Condition
@onready var preview_image = $MarginContainer/VBoxContainer/MarginContainer/TextureRect
@onready var logo = $MarginContainer/VBoxContainer/MarginContainer/TextureRect/overlays/thsirt_logo
@onready var brand_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer6/MarginContainer/Brand
@onready var product_label_name = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/Product_Name
@onready var pattern = $MarginContainer/VBoxContainer/MarginContainer/TextureRect/overlays/tshirt_pattern
@onready var seller_name = $"../../../seller_info/TextureRect/seller_name"
var colours: Array = ["white","yellow", "red", "green", "blue", "black", "purple", "pink", "cyan", "orange"]
var socks_shader = preload("res://shaders/color_swap_sock.gdshader")
var tshirt_shader = preload("res://shaders/color_swap_t_shirt.gdshader")
var socks_texture = preload("res://shaders/socks_colours.png")
var tshirt_texture = preload("res://shaders/tshirt_colours.png")
var trousers_texture = preload("res://shaders/trousers_colours.png")
var shorts_texture = preload("res://shaders/shorts_colours.png")
var boxers_texture = preload("res://shaders/boxers_colours.png")
var conceal_texture = preload("res://shaders/conceal_colours.png")
var pattern_texture = preload("res://shaders/pattern_colors.png")

	
func display_product_info(sprite: AnimatedSprite2D, data: Dictionary) -> void:
	preview_image.visible = true
	seller_name.text = data["seller_name"]
	if sprite:
		preview_image.texture = sprite.sprite_frames.get_frame_texture("default", sprite.frame)
	
	if data["pattern_type"] != "none" and data["pattern_type"] != null:
		pattern.show()
		pattern.play(data["pattern_type"])
		pattern.pause()
		pattern.frame = sprite.frame
	else:
		pattern.hide()
			
	product_label_name.text = name_generator(data)
	
	if data["color2"] == "":
		color_label.text = "Colour: " + data["color1"].capitalize()
	else:
		color_label.text = "Colour: " + data["color1"].capitalize() + " & " +  data["color2"].capitalize()
	
	var price_string = str(data["price"])
	if price_string[-2] == ".":
		price_label.text = "$" + str(data["price"]) + "0"
	else:
		price_label.text = "$" + str(data["price"])
	shipping_label.text = "Shipping Time: " + str(data["shippingTime"]) + " days"
	condition_label.text = "Condition: " + str(data["condition"])
	brand_label.text = "Brand: " + data["brand"].capitalize()
	
	if data["cd"] == true:
		brand_label.text = "Genre: " + data["genre"].capitalize()
	
	var color_index = data["number"]
		
	if data["condition"] == "Minted":
		condition_label.self_modulate = Color8(62, 180, 137) # mint colour
	else:
		condition_label.self_modulate = Color8(255,255,255)
		
	if preview_image.material == null:
		preview_image.material = ShaderMaterial.new()
	
	if not pattern.material is ShaderMaterial:
		pattern.material = ShaderMaterial.new()
		
	if data["type"] == "socks":
		preview_image.material.shader = tshirt_shader
		
		preview_image.material.set_shader_parameter("palette_texture", socks_texture)
		preview_image.material.set_shader_parameter("tolerance", 0.1)
		preview_image.material.set_shader_parameter("color_count", 6)
		preview_image.material.set_shader_parameter("palette_count", 10)
		preview_image.material.set_shader_parameter("palette_index", color_index)
		
	elif data["type"] == "tshirt":
		preview_image.material.shader = tshirt_shader
		preview_image.material.set_shader_parameter("palette_texture", tshirt_texture)
		preview_image.material.set_shader_parameter("tolerance", 0.1)
		preview_image.material.set_shader_parameter("color_count", 5)
		preview_image.material.set_shader_parameter("palette_count", 10)
		preview_image.material.set_shader_parameter("palette_index", color_index)
	elif data["type"] == "shorts":
		preview_image.material.shader = tshirt_shader
		
		preview_image.material.set_shader_parameter("palette_texture", shorts_texture)
		preview_image.material.set_shader_parameter("tolerance", 0.1)
		preview_image.material.set_shader_parameter("color_count", 4)
		preview_image.material.set_shader_parameter("palette_count", 5)
		preview_image.material.set_shader_parameter("palette_index", color_index)
	elif data["type"] == "trousers":
		preview_image.material.shader = tshirt_shader
		
		preview_image.material.set_shader_parameter("palette_texture", trousers_texture)
		preview_image.material.set_shader_parameter("tolerance", 0.1)
		preview_image.material.set_shader_parameter("color_count", 4)
		preview_image.material.set_shader_parameter("palette_count", 5)
		preview_image.material.set_shader_parameter("palette_index", color_index)
	
	elif data["type"] == "boxers":
		preview_image.material.shader = tshirt_shader
		
		preview_image.material.set_shader_parameter("palette_texture", boxers_texture)
		preview_image.material.set_shader_parameter("tolerance", 0.2)
		preview_image.material.set_shader_parameter("color_count", 6)
		preview_image.material.set_shader_parameter("palette_count", 10)
		preview_image.material.set_shader_parameter("palette_index", color_index)
	
	elif data["type"] == "conceal_shoes":
		preview_image.material.shader = tshirt_shader
		
		preview_image.material.set_shader_parameter("palette_texture", conceal_texture)
		preview_image.material.set_shader_parameter("tolerance", 0.02)
		preview_image.material.set_shader_parameter("color_count", 11)
		preview_image.material.set_shader_parameter("palette_count", 6)
		preview_image.material.set_shader_parameter("palette_index", color_index)
	
	else:
		preview_image.material.shader = null
		
	if data["pattern_type"]:
		if data["pattern_type"] != "none":
			pattern.material.shader = tshirt_shader
			
			pattern.material.set_shader_parameter("palette_texture", pattern_texture)
			pattern.material.set_shader_parameter("tolerance", 0.05)
			pattern.material.set_shader_parameter("color_count", 4)
			pattern.material.set_shader_parameter("palette_count", 10)
			pattern.material.set_shader_parameter("palette_index", data["pattern_index"])
	else:
		pattern.material.shader = null
		
		
func display_logo(sprite: AnimatedSprite2D, data:Dictionary, frame):
	logo.animation = data["overlay_animation"]
	logo.frame = frame
	
		
	
func stop_logo() -> void:
	logo.stop()

func on_ready() -> void:
	preview_image.visible = false

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
