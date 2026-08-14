extends TabContainer





func _on_tab_selected(tab: int) -> void:
	if tab == 3:
		Global.on_bidding = true
	else:
		Global.on_bidding = false
