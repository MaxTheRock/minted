extends Control

var timer = 1
@onready var photo_holder = $photos
@onready var SFX = $CameraSound
@onready var camera = $camera
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta


func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shelf.tscn")



func _on_take_photo_pressed() -> void:
	if timer < 0:
		for child in photo_holder.get_children():
			child.queue_free()
		
		timer = 2.5
		camera.frame = 0
		camera.play()
		SFX.play()
		
		await camera.animation_finished
		$clear_photo.show()
		$TextureBG.show()
		var packed = preload("res://scenes/photo.tscn")
		var storage_ui = packed.instantiate()
		photo_holder.add_child(storage_ui)
		
		var final_position = Vector2(0, 0) 
		var start_position = Vector2(0, 800)
		
		storage_ui.position = start_position
		
		var tween = create_tween().set_parallel(true) 
		
		tween.tween_property(storage_ui, "position", final_position, 0.6)\
			.set_trans(Tween.TRANS_BACK)\
			.set_ease(Tween.EASE_OUT)


func _on_clear_photo_pressed() -> void:
	for child in photo_holder.get_children():
			child.queue_free()
	$clear_photo.hide()
	$TextureBG.hide()
