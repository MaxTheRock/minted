extends Sprite2D

@onready var label: Label = $Label
var label_shown: bool = false

func _ready() -> void:
	Global.inShelf = true
	Global.inWardrobe = false
	label.hide()

func _process(delta: float) -> void:
	if label_shown == true and Input.is_action_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/shelf.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	label_shown = true
	label.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	label_shown = false
	label.hide()
