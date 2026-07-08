extends Control

@onready var info_label = $PanelContainer/VBoxContainer/Info/Status_text
@onready var stages_image = $PanelContainer/VBoxContainer/Stages_image
@onready var estimate = $PanelContainer/VBoxContainer/Estimate/Estimate_text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	info_label.text = "Your parcel is " + ShippingHandler.status
	stages_image.frame = ShippingHandler.stage_image
	print(ShippingHandler.total_time*24)
	print(1-ShippingHandler.shipping_percentage/100)
	print("NUM: " + str(ShippingHandler.total_time*24 * (1-ShippingHandler.shipping_percentage/100)))
	estimate.text = "Estimated delivery time - " + str(int(round(ShippingHandler.total_time*24 * (1-ShippingHandler.shipping_percentage/100)))) + " hours"
