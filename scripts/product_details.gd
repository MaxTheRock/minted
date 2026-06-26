extends VBoxContainer

@onready var type_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/Type
@onready var color_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/Color
@onready var price_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/Price
@onready var shipping_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Shipping
@onready var condition_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer5/MarginContainer/Condition
@onready var preview_image = $MarginContainer/VBoxContainer/MarginContainer/TextureRect

var colours: Array = ["white","yellow", "red", "green", "blue", "black", "purple", "pink", "cyan", "orange"]
var socks_shader = preload("res://shaders/color_swap_sock.gdshader")
var tshirt_shader = preload("res://shaders/color_swap_t_shirt.gdshader")
var socks_texture = preload("res://shaders/socks_colours.png")
var tshirt_texture = preload("res://shaders/tshirt_colours.png")

func display_product_info(sprite: AnimatedSprite2D, type, color, price, shipping, condition, color_index) -> void:
	if sprite:
		preview_image.texture = sprite.sprite_frames.get_frame_texture("default", sprite.frame)
	type_label.text = "Type: " + str(type)
	color_label.text = "Colour: " + str(color)
	price_label.text = "Price: $" + str(price)
	shipping_label.text = "Shipping Time: " + str(shipping) + " days"
	condition_label.text = "Condition: " + str(condition)
	
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
	
	else:
		preview_image.material.shader = null
