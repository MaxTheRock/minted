extends Control

@onready var black_screen = $fade_in
func _ready() -> void:
	black_screen.modulate.a = 1.0
	

func fade_out_black_screen() -> void:
	var tween: Tween = create_tween()
	
	tween.tween_property(black_screen, "modulate:a", 0.0, 2.5)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
	tween.tween_callback(black_screen.hide)
