extends Control

@onready var grid_container = $News/ScrollContainer/GridContainer

func _ready() -> void:
	for i in range(2):
		var packed = preload("res://scenes/article.tscn")
		var storage_ui = packed.instantiate()
		grid_container.add_child(storage_ui)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
