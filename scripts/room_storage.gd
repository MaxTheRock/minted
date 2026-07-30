extends Sprite2D

@onready var label: Label = $Label
@onready var ani_sprite = $AnimatedSprite2D
var label_shown: bool = false

func _ready() -> void:
	label.hide()
	ani_sprite.stop()
	ani_sprite.frame = 0

func _process(delta: float) -> void:
	if label_shown == true and Input.is_action_pressed("interact"):
		Global.first_room = false
		get_tree().change_scene_to_file("res://scenes/storage.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Player_Detector":
		ani_sprite.play()
		label_shown = true
		label.show()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = false
		label.hide()
		ani_sprite.play_backwards()
