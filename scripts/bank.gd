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

var invest_request: float = 0.0

var selected: String = ""
var invest_selected: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.invested:
		%investButton.disabled = true
	else:
		%investButton.disabled = false
	%loan.hide()
	%popupBack.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.invested and Global.future != null:
		if Global.days_until(Global.future["day"], Global.future["month"], Global.future["year"]) == 0:
			Global.invested = false
			Global.invest_claimed = false
		else:
			%investButtonLabel.text = str(Global.days_until(Global.future["day"], Global.future["month"], Global.future["year"])) + " days"
	if Global.invest_claimed == false:
		%investButtonLabel.text = "Claim"
	elif !Global.invested:
		%investButtonLabel.text = "Invest"
	if current_popup != "none":
		%popupBack.show()
		%popup.show()
	else:
		%popupBack.hide()
		%popup.hide()
	if current_popup == "loan":
		%loan.show()
		%invest.hide()
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
	elif current_popup == "invest":
		%invest.show()
		%loan.hide()
	elif current_popup == "none":
		%loan.hide()
		%invest.hide()

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


func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		%bars.play("1")
		invest_selected = 1
		%lv1_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv2_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv3_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv4_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv5_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv6_inv_num.add_theme_color_override("font_color", Color.html("806847"))
	elif index == 1:
		%bars.play("2")
		invest_selected = 2
		%lv1_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv2_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv3_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv4_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv5_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv6_inv_num.add_theme_color_override("font_color", Color.html("806847"))
	elif index == 2:
		%bars.play("3")
		invest_selected = 3
		%lv1_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv2_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv3_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv4_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv5_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv6_inv_num.add_theme_color_override("font_color", Color.html("806847"))
	elif index == 3:
		%bars.play("4")
		invest_selected = 4
		%lv1_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv2_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv3_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv4_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv5_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv6_inv_num.add_theme_color_override("font_color", Color.html("806847"))
	else:
		%bars.play("5")
		invest_selected = 5
		%lv1_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv2_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv3_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv4_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv5_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv6_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))

func _on_option_button_item_focused(index: int) -> void:
	if index == 0:
		%bars.play("1")
		invest_selected = 1
		%lv1_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv2_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv3_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv4_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv5_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv6_inv_num.add_theme_color_override("font_color", Color.html("806847"))
	elif index == 1:
		%bars.play("2")
		invest_selected = 2
		%lv1_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv2_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv3_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv4_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv5_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv6_inv_num.add_theme_color_override("font_color", Color.html("806847"))
	elif index == 2:
		%bars.play("3")
		invest_selected = 3
		%lv1_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv2_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv3_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv4_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv5_inv_num.add_theme_color_override("font_color", Color.html("806847"))
		%lv6_inv_num.add_theme_color_override("font_color", Color.html("806847"))
	elif index == 3:
		%bars.play("4")
		invest_selected = 4
		%lv1_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv2_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv3_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv4_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv5_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv6_inv_num.add_theme_color_override("font_color", Color.html("806847"))
	else:
		%bars.play("5")
		invest_selected = 5
		%lv1_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv2_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv3_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv4_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv5_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))
		%lv6_inv_num.add_theme_color_override("font_color", Color.html("ffffff"))

func invest_calc(money, option):
	if option == 1:
		return snapped(money * 1.0071, 0.001)
	elif option == 2:
		return snapped(money * 1.0156, 0.001)
	elif option == 3:
		return snapped(money * 1.0361, 0.001)
	elif option == 4:
		return snapped(money * 1.0746, 0.001)
	elif option == 5:
		return snapped(money * 1.1233, 0.001)
		

func _on_invest_money_text_changed(new_text: String) -> void:
	var regex := RegEx.new()
	regex.compile("^-?\\d*\\.?\\d{0,2}$")
	if not regex.search(new_text):
		var caret : int = %investMoney.caret_column
		%investMoney.text = new_text.substr(0, new_text.length() - 1)
		%investMoney.caret_column = caret - 1
		return

	if new_text.is_valid_float():
		var value: float = new_text.to_float()
		invest_request = new_text.to_float()
		%lv1_inv_num.text = "$" + str(value)
		%lv2_inv_num.text = "$" + str(invest_calc(value, 1))
		%lv3_inv_num.text = "$" + str(invest_calc(value, 2))
		%lv4_inv_num.text = "$" + str(invest_calc(value, 3))
		%lv5_inv_num.text = "$" + str(invest_calc(value, 4))
		%lv6_inv_num.text = "$" + str(invest_calc(value, 5))


func _on_texture_button_2_pressed() -> void:
	current_popup = "invest"

func _on_invest_button_pressed() -> void:
	if Global.money >= invest_request and Global.invest_claimed:
		Global.money -= invest_request
		%investButton.disabled = true
		if invest_selected == 1:
			Global.future = Global.add_to_date(7, 0)
			Global.bank_money += invest_calc(invest_request, 1)
		elif invest_selected == 2:
			Global.future = Global.add_to_date(14,0)
			Global.bank_money += invest_calc(invest_request, 2)
		elif invest_selected == 3:
			Global.future = Global.add_to_date(0,1)
			Global.bank_money += invest_calc(invest_request, 3)
		elif invest_selected == 4:
			Global.future = Global.add_to_date(0,2)
			Global.bank_money += invest_calc(invest_request, 4)
		elif invest_selected == 5:
			Global.future = Global.add_to_date(0,3)
			Global.bank_money += invest_calc(invest_request, 5)
		Global.invested = true
	elif Global.invest_claimed == false:
		Global.money += Global.bank_money
		Global.bank_money = 0
		Global.invest_claimed = true
