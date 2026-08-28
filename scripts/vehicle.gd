extends Node2D

var speed: float
var saved_speed: float
var direction: String = ""
var driver_types: Array = [100.0, 150.0, 200.0, 300.0]

@onready var front_detection: Area2D = $front_detection

func _ready() -> void:
	speed = driver_types.pick_random()

func _process(delta: float) -> void:
	if speed > 350:
		speed = 350
	
	if direction == "left":
		if front_detection.get_child_count() > 1:
			$front_detection/right.queue_free()
		position.x -= speed * delta
		if position.x <= 0:
			queue_free()
	elif direction == "right":
		if front_detection.get_child_count() > 1:
			$front_detection/left.queue_free()
		position.x += speed * delta
		if position.x >= 1800:
			queue_free()

	var none_match = front_detection.get_overlapping_areas().all(func(a): return a.get_parent() == self or a.name != "vehicle_hitbox")
	if none_match and randf() < 0.01:
		speed += 50

func _on_front_detection_area_entered(area: Area2D) -> void:
	var object = area.get_parent()
	if area.name == "vehicle_hitbox":
		saved_speed = speed
		speed = object.speed


func _on_front_detection_area_exited(area: Area2D) -> void:
	speed = saved_speed
