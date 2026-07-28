extends Sprite2D

@onready var label: Label = $Label
var label_shown: bool = false

func _ready() -> void:
	label.hide()

func _process(delta: float) -> void:
	for poster in $poster_item/TextureButton.get_children():
		poster.hide()
	
	var selected_poster = null
	if Inventory.display_poster:
		selected_poster = $poster_item/TextureButton.get_node_or_null(Inventory.display_poster[0]["type"])

		
	if selected_poster != null:
		selected_poster.show()
		
	if label_shown == true and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/poster_menu.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = true
		label.show()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Player_Detector":
		label_shown = false
		label.hide()
