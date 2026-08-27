extends Control

@onready var building = $Building
@onready var room_label = $Control/InteractionPrompt
@onready var player = $player/Player
var moved: bool = false
var starting_position: Vector2 = Vector2(0.0, -1.5)

func _ready() -> void:
	building.modulate.a = 0.22
	room_label.hide()
	Global.outside = true
	moved = false
	player.position = starting_position

func _process(delta: float) -> void:
	if Global.current_interactable == self and Input.is_action_pressed("interact") and not Global.action_just_pressed and round_to_decimal(player.position) != starting_position:
		Global.action_just_pressed = true
		Global.first_room = false
		Global.outside = false
		get_tree().change_scene_to_file("res://scenes/room.tscn")

func _on_building_area_area_entered(area: Area2D) -> void:
	if area.name == "Player_Detector":
		building.modulate.a = 0.01
		

func _on_building_area_area_exited(area: Area2D) -> void:
	if area.name == "Player_Detector":
		building.modulate.a = 0.10


func _on_door_area_area_entered(area: Area2D) -> void:
	Global.current_interactable = self
	room_label.show()


func _on_door_area_area_exited(area: Area2D) -> void:
	if Global.current_interactable == self:
			Global.current_interactable = null
			room_label.hide()
	
func round_to_decimal(vec: Vector2, decimals: int = 1) -> Vector2:
	var factor = pow(10, decimals)
	return Vector2(
		round(vec.x * factor) / factor,
		round(vec.y * factor) / factor
	)
