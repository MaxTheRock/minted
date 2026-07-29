extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var move_speed: float = 40.0
var spin_speed: float = 0.1
var screen_width: float = 1280.0

func setup(
	start_position: Vector2,
	texture: Texture2D,
	new_speed: float,
	new_spin_speed: float,
	new_scale: float,
	new_screen_width: float
) -> void:
	position = start_position
	sprite.texture = texture

	move_speed = new_speed
	spin_speed = new_spin_speed
	scale = Vector2.ONE * new_scale
	screen_width = new_screen_width

func _process(delta: float) -> void:
	position.x += move_speed * delta
	rotation += spin_speed * delta

	if position.x > screen_width + 150.0:
		queue_free()
