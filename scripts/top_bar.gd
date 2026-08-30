extends PanelContainer

@onready var money_ui = $back_nodes/CenterContainer/Money
@onready var time_ui = $Right/Time_Container/HBoxContainer/Control/Time
@onready var date_ui = $Right/Time_Container/HBoxContainer/Date
var money_string: String = ""

func _process(delta):
	money_string = ""
	if Global.money < 100:
		money_string += "0"
	money_string += str(calc_money_round(round(Global.money * 100.0) / 100.0))
	if str(Global.money)[str(Global.money).length() - 2] == ".":
		money_string += "0"
	money_string += calc_money_addon(round(Global.money * 100.0) / 100.0)
	money_string += "  "
	
	money_ui.text = money_string
	time_ui.text = Global.get_time_text()
	date_ui.text = Global.get_date_text()

func calc_money_addon(money) -> String:
	if money > 1000000000:
		return "b"
	elif money > 1000000:
		return "m"
	elif money > 1000:
		return "k"
	else:
		return ""

func calc_money_round(money) -> float:
	if money > 1000000000:
		return money / 1000000000
	elif money > 1000000:
		return money / 1000000
	elif money > 1000:
		return money / 1000
	else:
		return money
