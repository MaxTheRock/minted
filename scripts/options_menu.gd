extends Control




func _on_texture_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1280,720))
		2:
			DisplayServer.window_set_size(Vector2i(960,540))
		3:
			DisplayServer.window_set_size(Vector2i(854,480))
		
