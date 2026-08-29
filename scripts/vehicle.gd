extends Node2D

var speed: float
var saved_speed: float
var direction: String = ""
var driver_types: Array = [100.0, 150.0, 200.0, 300.0]

@onready var front_detection: Area2D = $front_detection

func _ready() -> void:
	speed = driver_types.pick_random()
	saved_speed = speed


func _process(delta: float) -> void:
	if speed > 350:
		speed = 350

	for area in front_detection.get_overlapping_areas():
		if area.name == "traffic_light_area":
			var light = area.get_parent()

			if light.current_color == "red" or light.current_color == "amber_end":
				speed = 0.0
			else:
				speed = saved_speed

	var none_match = front_detection.get_overlapping_areas().all(
		func(a):
			return a.get_parent() == self or (
				a.name != "vehicle_hitbox" and
				a.name != "traffic_light_area"
			)
	)

	if none_match and randf() < 0.01:
		saved_speed += 50
		speed = saved_speed

	# Movement
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


func _on_front_detection_area_entered(area: Area2D) -> void:
	var object = area.get_parent()

	if area.name == "vehicle_hitbox":
		saved_speed = speed
		speed = object.speed

	elif area.name == "traffic_light_area":
		var light = area.get_parent()

		if light.current_color == "red" or light.current_color == "amber_end":
			saved_speed = speed
			speed = 0.0


func _on_front_detection_area_exited(area: Area2D) -> void:
	if area.name == "vehicle_hitbox":
		speed = saved_speed

	elif area.name == "traffic_light_area":
		if area.get_parent().current_color != "red" or area.get_parent().current_color != "amber_end":
			speed = saved_speed
