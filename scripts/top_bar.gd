extends PanelContainer

@onready var money_ui = $Right/Money_Container/Money
@onready var time_ui = $Right/Time_Container/HBoxContainer/Control/Time
@onready var date_ui = $Right/Time_Container/HBoxContainer/Date

func _process(delta):
	money_ui.text = "$" + str(round(Global.money * 100.0) / 100.0)

	time_ui.text = Global.get_time_text()
	date_ui.text = Global.get_date_text()
