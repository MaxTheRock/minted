extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_ui.tscn")


func _on_options_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")
