extends Control

@onready var smallLoanButton1: TextureButton = %loanButton1
@onready var smallLoanButton2: TextureButton = %loanButton2
@onready var smallLoanButton3: TextureButton = %loanButton3

@onready var amountNumber: Label = %amountNumber
@onready var interestNumber: Label = %interestNumber
@onready var repayNumber: Label = %repayNumber

var current_popup: String = "none"

var loan_value: int = 0
var loan_interest: float = 0.0
var loan_days: int = 0

var selected: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%loan.hide()
	%popupBack.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_popup != "none":
		%popupBack.show()
		%popup.show()
	else:
		%popupBack.hide()
		%popup.hide()
	if current_popup == "loan":
		%loan.show()
		if selected == "small":
			loan_value =  100
			loan_interest = 5.0
			loan_days = 2
		elif selected == "medium":
			loan_value =  500
			loan_interest = 12.0
			loan_days = 7
		elif selected == "large":
			loan_value =  2000
			loan_interest = 25.0
			loan_days = 15
		else:
			loan_value =  0
			loan_interest = 0.0
			loan_days = 0
		
		amountNumber.text = "$" + str(loan_value)
		interestNumber.text = str(loan_interest) + "%"
		repayNumber.text = str(loan_days) + " rent days"
	elif current_popup == "none":
		%loan.hide()

func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/outside.tscn")


func _on_loan_button_1_pressed() -> void:
	selected = "small"


func _on_loan_button_1_mouse_entered() -> void:
	smallLoanButton1.modulate.a = 0.7


func _on_loan_button_1_mouse_exited() -> void:
	smallLoanButton1.modulate.a = 1.0


func _on_loan_button_2_pressed() -> void:
	selected = "medium"


func _on_loan_button_2_mouse_entered() -> void:
	smallLoanButton2.modulate.a = 0.7


func _on_loan_button_2_mouse_exited() -> void:
	smallLoanButton2.modulate.a = 1.0


func _on_loan_button_3_pressed() -> void:
	selected = "large"


func _on_loan_button_3_mouse_entered() -> void:
	smallLoanButton3.modulate.a = 0.7


func _on_loan_button_3_mouse_exited() -> void:
	smallLoanButton3.modulate.a = 1.0


func _on_confirm_button_pressed() -> void:
	if Global.loan_info == [0,0,0]:
		Global.money += loan_value
		Global.loan_info[0] = loan_value
		Global.loan_info[1] = loan_days
		Global.loan_info[2] = loan_interest
		%confirmButtonLabel.text = "CONFIRMED"
		await get_tree().create_timer(3.0).timeout
		%confirmButtonLabel.text = "Confirm"

func _on_confirm_button_mouse_entered() -> void:
	%confirmButton.modulate.a = 0.7


func _on_confirm_button_mouse_exited() -> void:
	%confirmButton.modulate.a = 1.0


func _on_popup_back_pressed() -> void:
	current_popup = "none"


func _on_texture_button_pressed() -> void:
	current_popup = "loan"
