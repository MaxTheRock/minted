extends TabContainer


func _ready() -> void:
	var tab = current_tab
	if tab == 3:
		Global.on_bidding = true
	else:
		Global.on_bidding = false
	if tab == 0:
		Global.on_market = true
	else:
		Global.on_market = false

func _on_tab_selected(tab: int) -> void:
	if tab == 3:
		Global.on_bidding = true
	else:
		Global.on_bidding = false
	if tab == 0:
		Global.on_market = true
	else:
		Global.on_market = false
