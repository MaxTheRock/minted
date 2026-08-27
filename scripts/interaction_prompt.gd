extends Control

@export var key_letter: String = "F"
@export var detail_text: String = "Interact"

@onready var key_letterlabel: Label = $letter
@onready var detail_textlabel: Label = $detail

func _ready() -> void:
	key_letterlabel.text = key_letter
	detail_textlabel.text = detail_text
