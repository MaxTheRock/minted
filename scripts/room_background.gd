extends Node2D

@export var background_box_scene: PackedScene = preload("res://scenes/BackgroundBox.tscn")
@export var box_skins: Array[Texture2D]

@export var minimum_spawn_time: float = 0.8
@export var maximum_spawn_time: float = 2.0

@export var minimum_speed: float = 20.0
@export var maximum_speed: float = 60.0

@export var minimum_scale: float = 0.5
@export var maximum_scale: float = 1.5

@export var particle_scale: float = 1.0

@export var maximum_spin_speed: float = 0.25

var spawn_timer: float = 0.0
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	reset_spawn_timer()

func _process(delta: float) -> void:
	spawn_timer -= delta

	if spawn_timer <= 0.0:
		spawn_box()
		reset_spawn_timer()

func spawn_box() -> void:
	if background_box_scene == null:
		return

	if box_skins.is_empty():
		return

	var box = background_box_scene.instantiate()
	add_child(box)

	var random_skin: Texture2D = box_skins.pick_random()

	var start_position := Vector2(
		-150.0,
		randf_range(0.0, screen_size.y)
	)

	var speed := randf_range(minimum_speed, maximum_speed)
	var box_scale := randf_range(minimum_scale, maximum_scale) * particle_scale
	var spin := randf_range(
		-maximum_spin_speed,
		maximum_spin_speed
	)

	box.setup(
		start_position,
		random_skin,
		speed,
		spin,
		box_scale,
		screen_size.x
	)

func reset_spawn_timer() -> void:
	spawn_timer = randf_range(
		minimum_spawn_time,
		maximum_spawn_time
	)
