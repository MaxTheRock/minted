extends PanelContainer

@onready var home_screen = get_node("/root/MainUI/Home")
@onready var market_screen = get_node("/root/MainUI/Market")
@onready var newspaper_screen = get_node("/root/MainUI/Newspaper")
@onready var trading_screen = get_node("/root/MainUI/Trading")
@onready var options_screen = get_node("/root/MainUI/Options")

func _on_home_pressed() -> void:
	home_screen.show()
	market_screen.hide()
	newspaper_screen.hide()
	trading_screen.hide()
	options_screen.hide()

func _on_market_pressed() -> void:
	home_screen.hide()
	market_screen.show()
	newspaper_screen.hide()
	trading_screen.hide()
	options_screen.hide()


func _on_newspaper_pressed() -> void:
	home_screen.hide()
	market_screen.hide()
	newspaper_screen.show()
	trading_screen.hide()
	options_screen.hide()

func _on_trading_pressed() -> void:
	home_screen.hide()
	market_screen.hide()
	newspaper_screen.hide()
	trading_screen.show()
	options_screen.hide()


func _on_options_pressed() -> void:
	home_screen.hide()
	market_screen.hide()
	newspaper_screen.hide()
	trading_screen.hide()
	options_screen.show()
