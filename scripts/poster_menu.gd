extends Control

@onready var close_button: Button = $Close
@onready var put_back_button: Button = $put_back

func _ready() -> void:
	if Inventory.display_poster.size() > 0:
		put_back_button.show()
	else:
		put_back_button.hide()

func _on_close_pressed() -> void:
	# Return to the room scene
	Global.goto_scene("res://scenes/room.tscn")

func _on_put_back_pressed() -> void:
	if Inventory.display_poster.size() > 0:
		var poster_data = Inventory.display_poster.pop_at(0)
		
		Inventory.player_inventory.append(poster_data)
		Inventory.player_inventory_weight += poster_data.get("shippingValue", 0)
		
		get_tree().reload_current_scene()
