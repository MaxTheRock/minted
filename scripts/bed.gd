extends Sprite2D

@onready var label: Label = $Label
var label_shown: bool = false

func _ready() -> void:
	label.hide()

func _process(_delta: float) -> void:
	if label_shown == true and Input.is_action_pressed("interact"):
		Global.first_room = false
		if Global.hour >= 21 or Global.hour <= 7:
			get_tree().change_scene_to_file("res://scenes/sleep.tscn")
		else:
			print("Not bed time yet...")
			

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = true
		label.show()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = false
		label.hide()
