extends Control

@onready var building = $Building
@onready var room_label = $Control/InteractionPrompt
@onready var bank_label = $bank/InteractionPrompt
@onready var player = $player/Player
var moved: bool = false
var starting_position: Vector2 = Vector2(0.0, -1.5)
var target_scene: String = ""
var left = true
@onready var sleep_bar = $CanvasLayer/sleep/sleep_bar
@onready var left_bar = $CanvasLayer/sleep

func _ready() -> void:
	$CanvasLayer.show()
	building.modulate.a = 0.22
	room_label.hide()
	bank_label.hide()
	Global.outside = true
	moved = false
	if Global.outside_saved_position == Vector2(0,0):
		player.position = starting_position
	else:
		player.position = Global.outside_saved_position

func _process(delta: float) -> void:
	if Global.current_interactable == self and Input.is_action_pressed("interact") and not Global.action_just_pressed and round_to_decimal(player.position) != starting_position and target_scene != "":
		Global.action_just_pressed = true
		Global.first_room = false
		Global.outside = false
		sleep_bar.value = Global.sleep
		get_tree().change_scene_to_file(target_scene)
		print(player.position)

func _on_building_area_area_entered(area: Area2D) -> void:
	if area.name == "Player_Detector":
		building.modulate.a = 0.01

func _on_building_area_area_exited(area: Area2D) -> void:
	if area.name == "Player_Detector":
		building.modulate.a = 0.10

func _on_door_area_area_entered(area: Area2D) -> void:
	Global.current_interactable = self
	target_scene = "res://scenes/room.tscn"
	Global.outside_saved_position = player.position
	room_label.show()

func _on_door_area_area_exited(area: Area2D) -> void:
	if Global.current_interactable == self:
		Global.current_interactable = null
		target_scene = ""
		room_label.hide()

func round_to_decimal(vec: Vector2, decimals: int = 1) -> Vector2:
	var factor = pow(10, decimals)
	return Vector2(
		round(vec.x * factor) / factor,
		round(vec.y * factor) / factor
	)

func _on_bank_area_area_entered(area: Area2D) -> void:
	Global.current_interactable = self
	target_scene = "res://scenes/bank.tscn"
	Global.outside_saved_position = player.position
	bank_label.show()

func _on_bank_area_area_exited(area: Area2D) -> void:
	if Global.current_interactable == self:
		Global.current_interactable = null
		target_scene = ""
		bank_label.hide()

var tween: Tween
@onready var start_position: Vector2 = left_bar.position

func _on_slide_pressed() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	left = !left
	$CanvasLayer/sleep/slide.rotation_degrees += 180
	if left:
		
		var target_position = start_position 

		tween.tween_property(left_bar, "position", target_position, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)
	else:
		var target_position = start_position + Vector2(200, 0)

		tween.tween_property(left_bar, "position", target_position, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)
