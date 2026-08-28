extends Control

var vehicle = preload("res://scenes/vehicle.tscn")
var types: Array = ["car"]
var chosen_type: String = "car"

var left_spawn_locked: bool = false
var right_spawn_locked: bool = false

func _ready() -> void:
	print($l_detector/left_vehicle_detector.position)
	print($r_detector/right_vehicle_detector.position)
	generate_vehicle("left")
	generate_vehicle("right")

func _process(delta: float) -> void:
	if Global.vehicle_queue_left.size() > 0 and not left_spawn_locked:
		spawn_vehicle(Global.vehicle_queue_left[0], "left")
		Global.vehicle_queue_left.erase(Global.vehicle_queue_left[0])
	if Global.vehicle_queue_right.size() > 0 and not right_spawn_locked:
		spawn_vehicle(Global.vehicle_queue_right[0], "right")
		Global.vehicle_queue_right.erase(Global.vehicle_queue_right[0])

func spawn_vehicle(type, direction):
	var instance = vehicle.instantiate()
	add_child(instance)

	if direction == "right":
		instance.position = Vector2(100,0)
		instance.direction = "right"
	elif direction == "left":
		instance.position = Vector2(1800,90)
		instance.direction = "left"
	
func generate_vehicle(queue):
	chosen_type = types.pick_random()
	if queue == "left":
		Global.vehicle_queue_left.append(chosen_type)
	else:
		Global.vehicle_queue_right.append(chosen_type)


func _on_l_detector_area_exited(area: Area2D) -> void:
	if Global.vehicle_queue_left.size() < 10 and not left_spawn_locked:
		generate_vehicle("left")
		left_spawn_locked = true
		await get_tree().create_timer(2.0).timeout
		left_spawn_locked = false
		

func _on_r_detector_area_exited(area: Area2D) -> void:
	if Global.vehicle_queue_right.size() < 10 and not right_spawn_locked:
		generate_vehicle("right")
		right_spawn_locked = true
		await get_tree().create_timer(2.0).timeout
		right_spawn_locked = false
		
