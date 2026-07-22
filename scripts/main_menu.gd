extends Control

func _ready() -> void:
	AudioManager.play_music(AudioManager.background_menu_music)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_ui.tscn")


func _on_options_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
