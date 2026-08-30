extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detector: Area2D = $traffic_light_area

var current_color: String = "green"

func _ready() -> void:
	run_traffic_light()

func run_traffic_light():
	while true:
		sprite.play("green")
		current_color = "green"
		await get_tree().create_timer(5.0).timeout

		sprite.play("amber")
		current_color = "amber_start"
		await get_tree().create_timer(2.0).timeout

		sprite.play("red")
		current_color = "red"
		await get_tree().create_timer(5.0).timeout

		sprite.play("amber")
		current_color = "amber_end"
		await get_tree().create_timer(2.0).timeout
