extends Control

var mail_user_scene = preload("res://scenes/mail_user.tscn")
var shipping_status = preload("res://scenes/shipping_status.tscn")
@onready var user_container = $VBoxContainer/Sections/MarginContainer/Users
@onready var message_container = $VBoxContainer/Sections/MarginContainer2/Message

func _ready():
	Global.create_mail.connect(_on_create_mail)

func _on_create_mail():
	var mail = mail_user_scene.instantiate()
	user_container.add_child(mail)
	var message = shipping_status.instantiate()
	message_container.add_child(message)
