extends Control

func _ready() -> void:
	AudioManager.play_music(AudioManager.background_menu_music)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_ui.tscn")
	Inventory.player_inventory.append({ "type": "trousers", "number": 1, "color": "black", "price": 1.8, "shippingTime": 2.0, "shippingValue": 1, "condition": "Poor", "condition_price_mult": 0.4, "brand": "none", "selected_brand": "none", "genre": "none", "cd": false, "rarity": "common", "logo_animation": &"ele_minimalistic_black" })


func _on_options_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
