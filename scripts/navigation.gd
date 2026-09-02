extends PanelContainer

@onready var home_screen = get_node("/root/MainUI/Home")
@onready var newspaper_screen = get_node("/root/MainUI/Newspaper")
@onready var options_screen = get_node("/root/MainUI/Options")
@onready var mintora_screen = get_node("/root/MainUI/Mintora")

func _ready() -> void:
	home_screen.show()
	newspaper_screen.hide()
	options_screen.hide()
	mintora_screen.hide()

func _on_home_pressed() -> void:
	home_screen.show()
	newspaper_screen.hide()
	options_screen.hide()
	mintora_screen.hide()
	Global.on_market = false
	
func _on_newspaper_pressed() -> void:
	home_screen.hide()
	newspaper_screen.show()
	options_screen.hide()
	mintora_screen.hide()
	Global.on_market = false

func _on_mintora_pressed() -> void:
	home_screen.hide()
	newspaper_screen.hide()
	options_screen.hide()
	mintora_screen.show()
	
func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")

func _on_exit_pressed() -> void:
	Global.on_computer = false
	get_tree().change_scene_to_file("res://scenes/room.tscn")
