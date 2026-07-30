extends Sprite2D

@onready var label: Label = $Label
@onready var computer_light = $computer_light
var label_shown: bool = false

func _ready() -> void:
	label.hide()
	randomize()
	run_loop()

func run_loop() -> void:
	while true:
		await get_tree().create_timer(randf_range(0.01, 1)).timeout
		flickering()

func _process(delta: float) -> void:
	if label_shown == true and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/main_ui.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = true
		label.show()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = false
		label.hide()
		
func flickering() -> void:
	if computer_light.modulate == Color(1, 1, 1, 0.2):
		computer_light.modulate = Color(1, 1, 1, 0.25)
	else:
		computer_light.modulate = Color(1, 1, 1, 0.2)
