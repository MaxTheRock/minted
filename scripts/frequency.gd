@tool
extends HSlider

const TICK_VALUES = [125.0, 165.0]

@export var tick_color: Color = Color(1.0, 0.369, 1.0, 0.6)
@export var tick_thickness: float = 2.0
@export var tick_height: float = 12.0

func _ready() -> void:
	value_changed.connect(func(_val): queue_redraw())

func _draw() -> void:
	for val in TICK_VALUES:
		var ratio = (val - min_value) / (max_value - min_value)
		var tick_x = ratio * size.x
		var center_y = size.y / 2.0
		var start_point = Vector2(tick_x, center_y - (tick_height / 2.0))
		var end_point = Vector2(tick_x, center_y + (tick_height / 2.0))
		draw_line(start_point, end_point, tick_color, tick_thickness)
