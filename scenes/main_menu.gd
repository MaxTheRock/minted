extends Control

@onready var home_screen = get_node("/root/MainUI/Home")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_play_button_pressed() -> void:
	self.hide()
	home_screen.show()
