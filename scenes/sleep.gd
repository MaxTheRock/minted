extends Control

@onready var time_ui = $Control/Time


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Global.hour >= 21 or Global.hour < 7:
		Global.CLOCK_SPEED = 0.01
	else:
		Global.CLOCK_SPEED = 0.5
		get_tree().change_scene_to_file("res://scenes/room.tscn")
	time_ui.text = Global.get_time_text()
