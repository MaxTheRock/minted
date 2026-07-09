extends Control

var shipping_entry = null
var estimated_hours = 0
var timer = 1

func _process(delta):
	if shipping_entry == null:
			return
	var progress = ShippingHandler.get_progress(shipping_entry)
	print(progress)
	estimated_hours = progress["total_time"] * 24 * (1 - progress["percentage"] / 100)
	if estimated_hours <= 0 and timer > 0:
		timer -= delta # deletes completes delivery text after a second.
	else:
		queue_free()
