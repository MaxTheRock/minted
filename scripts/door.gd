extends Control

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Global.current_interactable == self and Input.is_action_pressed("interact"):
		Global.first_room = false
		get_tree().change_scene_to_file("res://scenes/outside.tscn")


func _on_area_2d_area_entered(area: Area2D) -> void:
	Global.current_interactable = self
	label.show()


func _on_area_2d_area_exited(area: Area2D) -> void:
	if Global.current_interactable == self:
			Global.current_interactable = null
			label.hide()
