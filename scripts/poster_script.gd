extends Node2D

@onready var poster_sprites := {
	"spud_poster": $TextureButton/spud_poster,
	"potion_poster": $TextureButton/potion_poster,
	"banana_poster": $TextureButton/banana_poster,
}

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var hovering = false

@onready var details_ui = get_node_or_null("/root/MainUI/Market/VBoxContainer/Sections/Product_Details")

func _process(delta):
	if !hovering:
		for child in get_tree().get_nodes_in_group("clothes"):
			if child.owner == self:
				child.rotation_degrees = 0
		return

func _on_texture_button_mouse_entered():
	hovering = true
	$FrameTimer.start()

func _on_texture_button_mouse_exited():
	hovering = false
	$FrameTimer.stop()
	for child in get_tree().get_nodes_in_group("clothes"):
		child.stop()
		if child.owner == self:
			child.frame = 0

func _on_frame_timer_timeout():
	for child in get_tree().get_nodes_in_group("clothes"):
		if child.visible and child is AnimatedSprite2D and child.owner == self:
			var max_frames = child.sprite_frames.get_frame_count("default")
			var new_frame = rng.randi_range(0, max_frames - 1)
			while new_frame == child.frame and max_frames > 1:
				new_frame = rng.randi_range(0, max_frames - 1)
			child.frame = new_frame

func button_enter():
	$FrameTimer.start()
	
func button_exit():
	$FrameTimer.stop()
	for child in get_tree().get_nodes_in_group("clothes"):
		if child.owner == self:
			child.frame = 0
