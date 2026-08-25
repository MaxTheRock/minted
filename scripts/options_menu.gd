extends Control

@onready var resolution: OptionButton = $TabContainer/Video/window_settings/resolution
@onready var window_mode: OptionButton = $TabContainer/Video/window_settings/window_mode

func _ready() -> void:
	window_mode.select(1)
	var screen := DisplayServer.window_get_current_screen()
	var screen_size := DisplayServer.screen_get_size(screen)
	
	if screen_size.x < 3840 or screen_size.y < 2160:
		resolution.remove_item(0)

	if screen_size.x < 2560 or screen_size.y < 1440:
		resolution.remove_item(0)

	resolution.select(0)

func _on_texture_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func set_window_size(size: Vector2i) -> void:
	DisplayServer.window_set_size(size)

	var screen := DisplayServer.window_get_current_screen()
	var screen_pos := DisplayServer.screen_get_position(screen)
	var screen_size := DisplayServer.screen_get_size(screen)

	var pos := screen_pos + (screen_size - size) / 2
	DisplayServer.window_set_position(pos)

func _on_resolution_item_selected(index: int) -> void:
	var text := resolution.get_item_text(index)

	match text:
		"3840x2160 (4K)":
			set_window_size(Vector2i(3840, 2160))
		"2560x1440 (2K)":
			set_window_size(Vector2i(2560, 1440))
		"1280x720 (default)":
			set_window_size(Vector2i(1280, 720))
		"640x360":
			set_window_size(Vector2i(640, 360))


func _on_window_mode_item_selected(index: int) -> void:
	var text := window_mode.get_item_text(index)

	match text:
		"Fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		"Windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		"Borderless":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
