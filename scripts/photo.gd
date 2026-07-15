extends Node2D

@onready var faces = $faces
@onready var filter = $filter

var rng = RandomNumberGenerator.new()
var total_weight = 0
var face_data: Array = [1,1,1,1,0.1,1,1,0.1,1,1,1,1,1,1,1,1,1,1,1,1]
func _ready() -> void:
	total_weight = 0
	rng.randomize()
	for i in face_data:
		total_weight += i
	var num = rng.randf_range(0, total_weight)
	var key: int = 0
	while num > face_data[key]:
		num -= face_data[key]
		key += 1
	faces.frame = key
	filter.play(Global.camera_quality)
