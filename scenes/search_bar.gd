extends Control

@export var url: String = ""
@onready var url_label = $PanelContainer/Left/PanelContainer/MarginContainer/MarginContainer/Label

func _ready() -> void:
	url_label.text = url
