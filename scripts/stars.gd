extends Control

var item
var item_data

@onready var star_1 = $"1"
@onready var star_2 = $"2"
@onready var star_3 = $"3"
@onready var star_4 = $"4"
@onready var star_5 = $"5"

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func set_item(new_item):
	item = new_item
	item_data = item.get_data()
	star_calc(item_data.seller_rating)
	
func star_calc(rating):
	if rating == 5.0:
		star_1.play("full")
		star_2.play("full")
		star_3.play("full")
		star_4.play("full")
		star_5.play("full")
	elif rating == 4.5:
		star_1.play("full")
		star_2.play("full")
		star_3.play("full")
		star_4.play("full")
		star_5.play("partial")
	elif rating == 4.0:
		star_1.play("full")
		star_2.play("full")
		star_3.play("full")
		star_4.play("full")
		star_5.play("none")
	elif rating == 3.5:
		star_1.play("full")
		star_2.play("full")
		star_3.play("full")
		star_4.play("partial")
		star_5.play("none")
	elif rating == 3.0:
		star_1.play("full")
		star_2.play("full")
		star_3.play("full")
		star_4.play("none")
		star_5.play("none")
	elif rating == 2.5:
		star_1.play("full")
		star_2.play("full")
		star_3.play("partial")
		star_4.play("none")
		star_5.play("none")
	elif rating == 2.0:
		star_1.play("full")
		star_2.play("full")
		star_3.play("none")
		star_4.play("none")
		star_5.play("none")
	elif rating == 1.5:
		star_1.play("full")
		star_2.play("partial")
		star_3.play("none")
		star_4.play("none")
		star_5.play("none")
	elif rating == 1.0:
		star_1.play("full")
		star_2.play("none")
		star_3.play("none")
		star_4.play("none")
		star_5.play("none")
	elif rating == 0.5:
		star_1.play("partial")
		star_2.play("none")
		star_3.play("none")
		star_4.play("none")
		star_5.play("none")
	else:
		star_1.play("none")
		star_2.play("none")
		star_3.play("none")
		star_4.play("none")
		star_5.play("none")
		
