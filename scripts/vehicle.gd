extends Node2D

var speed: float
var saved_speed: float
var direction: String = ""
var driver_types: Array = [100.0, 150.0, 200.0, 300.0]

@onready var front_detection: Area2D = $front_detection

@onready var van_wheel1: AnimatedSprite2D = $shippley_van/Sprite2D/wheel1
@onready var van_wheel2: AnimatedSprite2D = $shippley_van/Sprite2D/wheel2
@onready var car_wheel1: AnimatedSprite2D = $car/Sprite2D/wheel1
@onready var car_wheel2: AnimatedSprite2D = $car/Sprite2D/wheel2

func _ready() -> void:
	van_wheel1.play("default")
	van_wheel2.play("default")
	car_wheel1.play("default")
	car_wheel2.play("default")
	speed = driver_types.pick_random()
	saved_speed = speed


func _process(delta: float) -> void:
	if speed == 0.0:
		van_wheel1.stop()
		van_wheel2.stop()
		car_wheel1.stop()
		car_wheel2.stop()
	else:
		van_wheel1.play("default")
		van_wheel2.play("default")
		car_wheel1.play("default")
		car_wheel2.play("default")
	
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
		$shippley_van/Sprite2D.z_index = 4

		position.x -= speed * delta

		if position.x <= -1000:
			queue_free()

	elif direction == "right":
		if front_detection.get_child_count() > 1:
			$front_detection/left.queue_free()
			
		position.x += speed * delta
		$shippley_van/Sprite2D.z_index = 3
		if position.x >= 2800:
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

func skin(skin_name):
	$car.hide()
	$shippley_van.hide()
	if skin_name == "car":
		$car.show()
		$collisions/shippley_van.disabled = true
		$collisions/car.disabled = false
	elif skin_name == "shippley_van":
		$shippley_van.show()
		$collisions/shippley_van.disabled = false
		$collisions/car.disabled = true

func flip(left):
	if left:
		$shippley_van/Sprite2D.scale.x = -2.0
		$car/Sprite2D.scale.x = -2.0
	else:
		$shippley_van/Sprite2D.scale.x = 2.0
		$car/Sprite2D.scale.x = 2.0
