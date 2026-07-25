extends Sprite2D

@onready var label: Label = $Label
var label_shown: bool = false

func _ready() -> void:
	label.hide()

func _process(delta: float) -> void:
	for poster in $poster_item/TextureButton.get_children():
		poster.hide()

	var selected_poster = $poster_item/TextureButton.get_node_or_null(Global.room_poster)

	if selected_poster != null:
		selected_poster.show()
		
	if label_shown == true and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://scenes/poster_menu.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	label_shown = true
	label.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	label_shown = false
	label.hide()
