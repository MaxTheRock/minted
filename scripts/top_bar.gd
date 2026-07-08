extends PanelContainer

@onready var money_ui = $Right/Money_Container/Money
@onready var time_ui = $Right/Time_Container/Time

func _process(delta):
	money_ui.text = "$" + str(Global.money)
	time_ui.text = Global.get_time_text()
