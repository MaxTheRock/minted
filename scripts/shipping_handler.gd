extends Node

var shipping_list: Array = []
var shipping_percentage: float = 0.0
var status: String = ""
var stage_image = 0
var total_time = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	for item in shipping_list:
		total_time = item[0]["shippingTime"]
		shipping_percentage = ((Global.time_mins - item[1])/(total_time * 1440)) * 100
		if shipping_percentage <= 0.1:
			status = "Prepairing"
			stage_image = 0
		elif shipping_percentage == 25.0:
			status = "Packed"
			stage_image = 1
		elif shipping_percentage == 50.0:
			status = "In Transit"
			stage_image = 2
		elif shipping_percentage == 75.0:
			status = "Out for Delivery"
			stage_image = 3
		elif shipping_percentage == 100.0:
			status = "Delivered"
			stage_image = 4
			Inventory.wardrobe_inventory.append(item[0])
