extends Control
@onready var label = $Label
@onready var player = get_node("/root/" + get_tree().current_scene.name + "/player/Player")
var player_pos: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if Global.current_interactable == self and Input.is_action_pressed("interact") and player_pos != player.position:
		Global.first_room = false
		Global.outside = true
		get_tree().change_scene_to_file("res://scenes/outside.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	Global.current_interactable = self
	player_pos = player.position
	label.show()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if Global.current_interactable == self:
			Global.current_interactable = null
			label.hide()
