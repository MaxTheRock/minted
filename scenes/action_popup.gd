extends CanvasLayer

@onready var usernamePanel: Control = $username_change

func _ready() -> void:
	usernamePanel.hide()
	%username_field.text = Global.username
	%username_field.placeholder_text = "Enter Username"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_confirm_button_pressed() -> void:
	Global.username = %username_field.text
	usernamePanel.hide()


func _on_confirm_button_mouse_entered() -> void:
	%confirmButton.modulate.a = 0.7


func _on_confirm_button_mouse_exited() -> void:
	%confirmButton.modulate.a = 1
