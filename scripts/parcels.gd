extends Control

@onready var label: Label = $Label
var label_shown: bool = false

@onready var nodes = [null, $"1", $"2", $"3", $"4", $"5", $"6", $"7", $"8", $"9", $"10", $"11", $"12", $"13", $"14", $"15", $"16", $"17", $"18", $"19", $"20", $"21", $"22", $"23", $"24", $"25", $"26", $"27", $"28", $"29", $"30", $"31", $"32", $"33", $"34", $"35"]

func _ready() -> void:
	label.hide()

func _process(delta: float) -> void:
	for i in range(1, nodes.size()):
		nodes[i].visible = (i == ShippingHandler.shipping_value)
	if label_shown and Input.is_action_just_pressed("interact"):
		if ShippingHandler.delivered_list.size() > 0:
			Global.first_room = false
			get_tree().change_scene_to_file("res://scenes/parcel.tscn")
		else:
			print("No delivered items to collect")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = true
		label.show()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = false
		label.hide()
