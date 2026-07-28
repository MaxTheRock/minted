extends Sprite2D

@onready var label: Label = $Label
var label_shown: bool = false

func _ready() -> void:
	label.hide()

func _process(delta: float) -> void:
	if label_shown == true and Input.is_action_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/storage.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = true
		label.show()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = false
		label.hide()
