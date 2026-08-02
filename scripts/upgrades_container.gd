extends Control

const pricing = {
	"lv2_computer": 2000,
	"lv2_bed": 1000,
	"lv2_wardrobe": 500,
	"lv2_shelf": 1500
}

@onready var button = $Button/PanelContainer/MarginContainer/VBoxContainer/Button
@onready var sprite_container = $Button/PanelContainer/MarginContainer/VBoxContainer/Frame
@export var upgrade = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for sprite in sprite_container.get_children():
		if upgrade == sprite.name:                                 
			sprite.show()
			button.text = str(pricing.get(sprite.name, 0))
		else:
			sprite.hide()

func _process(delta: float) -> void:
	pass
