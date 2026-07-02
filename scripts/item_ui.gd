extends Control

@onready var item = $item
@onready var panel_container = $PanelContainer2
@onready var buy_button = $PanelContainer2/GridContainer/VBoxContainer/MarginContainer/Buy_Button

var xp_mult = 1

func _ready() -> void:
	item.rarity_ui.connect(_rarity_ui)
	if item.type == "":
		item.initialize_item()

func _rarity_ui(item_rarity) -> void:
	if item_rarity == "common":
		panel_container.self_modulate = Color8(245,255,255)
	elif item_rarity == "uncommon":
		panel_container.self_modulate = Color8(20,235,30)
		xp_mult = 1.2
	elif item_rarity == "rare":
		panel_container.self_modulate = Color8(54,136,177)
		xp_mult = 2
	elif item_rarity == "epic":
		panel_container.self_modulate = Color8(153,51,255)
		xp_mult = 4.5


func _on_buy_button_pressed() -> void:
	if Global.money >= item.price:
		Global.money -= item.price
		print("bought: ", item.type)
		Global.inventory.append([item.type, item.color, item.brand, item.selected_brand])
		print(Global.inventory)
		Global.xp += int(round(item.price*10)*xp_mult)
		queue_free()
	else:
		print("not enough money!")
	
func _on_buy_button_mouse_entered() -> void:
	item.button_enter()


func _on_buy_button_mouse_exited() -> void:
	item.button_exit()
