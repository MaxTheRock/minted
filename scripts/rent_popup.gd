extends Control
var landlord_quotes: Array = ["Time to pay up!", "Lucky day for me, eh!", "It's my favourite time of day!", "How is your reselling going?", "You're lucky that I'm your landlord!", "Look's like Minted won't work out for you...", "Hello again!", "My (least) favourite customer!", "You're on thin ice pal!", "Do I always look this stunning??", "Do you really class reselling as a job?", "Not even a miracle could change your mindset!","A dime higher and you'd be out of here."]
var total_rent: float
# Landlord speech
@onready var landlord_text1: Label = $landlord_text/landlord_text
@onready var landlord_text2: Label = $landlord_text/landlord_text2
@onready var landlord_image: AnimatedSprite2D = $landlord_image
# Price label
@onready var building_label1: Label = $Building/price1
@onready var building_label2: Label = $Building/price2
@onready var electrical_label1: Label = $Electrical/price1
@onready var electrical_label2: Label = $Electrical/price2
@onready var utilities_label1: Label = $Utilities/price1
@onready var utilities_label2: Label = $Utilities/price2
@onready var maintenance_label1: Label = $Maintenance/price1
@onready var maintenance_label2: Label = $Maintenance/price2
@onready var broadband_label1: Label = $Broadband/price1
@onready var broadband_label2: Label = $Broadband/price2
@onready var total_label1: Label = $Total/price1
@onready var total_label2: Label = $Total/price2
func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	refresh_popup()
func _on_visibility_changed() -> void:
	if visible:
		refresh_popup()
func refresh_popup() -> void:
	# Landlord Speech Bubble
	var quote = landlord_quotes.pick_random()
	landlord_text1.text = quote
	landlord_text2.text = quote
	landlord_image.play(str(randi_range(1, 7)))
	# Price
	building_label1.text = "$" + "%.2f" % Global.rent_building
	building_label2.text = "$" + "%.2f" % Global.rent_building
	electrical_label1.text = "$" + "%.2f" % Global.rent_electrical
	electrical_label2.text = "$" + "%.2f" % Global.rent_electrical
	utilities_label1.text = "$" + "%.2f" % Global.rent_utilities
	utilities_label2.text = "$" + "%.2f" % Global.rent_utilities
	maintenance_label1.text = "$" + "%.2f" % Global.rent_maintenance
	maintenance_label2.text = "$" + "%.2f" % Global.rent_maintenance
	broadband_label1.text = "$" + "%.2f" % Global.rent_broadband
	broadband_label2.text = "$" + "%.2f" % Global.rent_broadband
	total_rent = Global.rent_building + Global.rent_electrical + Global.rent_utilities + Global.rent_maintenance + Global.rent_broadband
	total_label1.text = "$" + "%.2f" % total_rent
	total_label2.text = "$" + "%.2f" % total_rent
func _on_pay_button_mouse_entered() -> void:
	$pay_container.modulate.a = 0.7
func _on_pay_button_mouse_exited() -> void:
	$pay_container.modulate.a = 1
func _on_pay_button_pressed() -> void:
	if Global.money >= total_rent:
		Global.money -= total_rent
		Global.rent_triggered = false
		Global.days_since_rent = 0
		RentPopup.visible = false
		Global.rent_building *= 1.32
		Global.rent_electrical *= 1.26
		Global.rent_utilities *= 1.12
		Global.rent_maintenance *= 1.1
		Global.rent_broadband_mult *= 1.07
		Global.rent_broadband = 0
		Global.mins_on_computer = 0
	else:
		print("Not enough - You lose!")
