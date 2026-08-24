extends Control

signal visibility_toggled(is_visible, target)

@export var tooltip_offset := Vector2(-150, 0)
@onready var panel = $TooltipPanel
@onready var name_label = $TooltipPanel/item_name
@onready var condition_bar = $TooltipPanel/condition_bar
@onready var condition_label = $TooltipPanel/condition_text
@onready var brand_icon = $TooltipPanel/brand_icon
@onready var brand_label = $TooltipPanel/brand_name
@onready var color1_tag = $TooltipPanel/tags2/color_tag/color1_tag
@onready var color2_tag = $TooltipPanel/tags2/color_tag/color2_tag
@onready var money_label = $TooltipPanel/money_text

var current_target = null

func _ready():
	panel.hide()
	panel.z_index = 5

func show_tooltip(target):
	$TooltipPanel/tags2/extra_info.show()
	$TooltipPanel/tags2/extra_info/extra_tag.play("default")
	current_target = target
	panel.show()
	visibility_toggled.emit(true, target)
	await get_tree().process_frame
	var vp_size = get_viewport().get_visible_rect().size
	var tooltip_size = panel.size
	var pos = target.global_position + Vector2(target.size.x + tooltip_offset.x, tooltip_offset.y)
	print(pos)
	if pos.x + tooltip_size.x > vp_size.x:
		pos.x = target.global_position.x - tooltip_size.x - tooltip_offset.x
	if pos.y + tooltip_size.y > vp_size.y:
		pos.y = target.global_position.y - tooltip_size.y - tooltip_offset.y
	panel.position = pos
	
	# Item fill
	var item = target.get_data()
	name_label.text = str(name_generator(item))
	condition_bar.play(str(item.condition).to_lower())
	condition_label.text = "Condition: " + str(item.condition)
	brand_icon.play(str(item.brand).to_lower())
	brand_label.text = str(item.brand)
	color1_tag.play(str(item.color1).to_lower())
	if str(item.color2).to_lower() == "":
		color2_tag.hide()
	else:
		color2_tag.play(str(item.color2).to_lower())
		color2_tag.show()

	money_label.text = str(item.price)
	
	if item.item_category[0]:
		$TooltipPanel/tags2/item_type/type_tag.play(item.item_category[0].to_lower())
	if item.cd:
		$TooltipPanel/tags2/extra_info/extra_tag.play("music")
	elif item.type == "potion_poster" or item.type == "spud_poster":
		$TooltipPanel/tags2/extra_info/extra_tag.play("poster")
	elif item.type == "camera" or item.type == "cd_player":
		$TooltipPanel/tags2/extra_info/extra_tag.play("placeable")
	elif item.item_category.size() == 2:
		$TooltipPanel/tags2/item_type/type_tag.play(item.item_category[1].to_lower())
	else:
		$TooltipPanel/tags2/extra_info.hide()
	if item.shippingValue == 1:
		$TooltipPanel/tags2/item_weight/weight_tag.play("light")
	elif item.shippingValue == 2:
		$TooltipPanel/tags2/item_weight/weight_tag.play("medium")
	elif item.shippingValue == 3:
		$TooltipPanel/tags2/item_weight/weight_tag.play("heavy")
	elif item.shippingValue >= 4:
		$TooltipPanel/tags2/item_weight/weight_tag.play("xl")
		
func hide_tooltip(target: Control):
	panel.hide()
	visibility_toggled.emit(false, target)
	current_target = null
	
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


func _on_hitbox_focus_exited() -> void:
	hide_tooltip(self)
