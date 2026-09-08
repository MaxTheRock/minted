extends CanvasLayer

@onready var label: Label = %FPSLabel


func _process(_delta):
	if Global.debug_enabled:
		label.text = "FPS: %d" % Engine.get_frames_per_second()
		label.show()
	else:
		label.hide()
