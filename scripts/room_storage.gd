extends Sprite2D

@onready var label: Control = $InteractionPrompt
@onready var ani_sprite = $AnimatedSprite2D
var label_shown: bool = false

func _ready() -> void:
	label.hide()
	ani_sprite.stop()
	ani_sprite.frame = 0

func _process(delta: float) -> void:
	if Global.current_interactable == self and Input.is_action_pressed("interact"):
		Global.first_room = false
		get_tree().change_scene_to_file("res://scenes/storage.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = true
		Global.current_interactable = self
		label.show()
		ani_sprite.play()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Player_Detector":
		if Global.current_interactable == self:
			Global.current_interactable = null
			label.hide()
		ani_sprite.play_backwards()
