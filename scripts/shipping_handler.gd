extends Node

var shipping_list: Array = []

func _process(delta: float) -> void:
	Inventory.current_ui_type = "shipping"
	for i in shipping_list:
		var entry = i
		var progress = get_progress(entry)
		if progress["percentage"] >= 100.0:
			shipping_list.erase(i)
			Inventory.wardrobe_inventory.append(entry[0])
			print(Inventory.wardrobe_inventory)

func get_progress(entry: Array) -> Dictionary:
	var total_time = entry[0]["shippingTime"]
	var elapsed = Global.time_mins - entry[1]
	var percentage = clamp((elapsed / (total_time * 1440)) * 100.0, 0.0, 100.0)

	var status = "Prepareing"
	var stage_image = 0
	if percentage >= 100.0:
		status = "Delivered"
		stage_image = 4
	elif percentage >= 75.0:
		status = "Out for Delivery"
		stage_image = 3
	elif percentage >= 50.0:
		status = "In Transit"
		stage_image = 2
	elif percentage >= 25.0:
		status = "Packed"
		stage_image = 1

	return {
		"status": status,
		"stage_image": stage_image,
		"total_time": total_time,
		"percentage": percentage,
	}
