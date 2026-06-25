extends VBoxContainer

@onready var type_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/Type
@onready var color_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/Color
@onready var price_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/Price
@onready var shipping_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer4/MarginContainer/Shipping
@onready var condition_label = $MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer5/MarginContainer/Condition
@onready var preview_image = $MarginContainer/VBoxContainer/MarginContainer/TextureRect

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func display_product_info(sprite: AnimatedSprite2D, type, color, price, shipping, condition) -> void:
	if sprite:
		preview_image.texture = sprite.sprite_frames.get_frame_texture("default", sprite.frame)
	type_label.text = "Type: " + str(type)
	color_label.text = "Colour: " + str(color)
	price_label.text = "Price: $" + str(price)
	shipping_label.text = "Shipping Time: " + str(shipping) + " days"
	condition_label.text = "Condition: " + str(condition)
