extends Control

func _ready() -> void:
	$AnimationPlayer.play("Fade in")
	await get_tree().create_timer(6.0).timeout
	$AnimationPlayer.play("Fade out")
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
