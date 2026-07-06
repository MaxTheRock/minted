extends Control

@onready var item = $item

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_remove_pressed() -> void:
	print(item.type)
	if item.type == "cd_player":
		get_tree().change_scene_to_file("res://scenes/cd_player.tscn")
