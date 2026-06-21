extends Control

func show_page(page_name):
	for child in get_children():
		child.visible = false
	
	get_node(page_name).visible = true


func _on_button_pressed() -> void:
	show_page("Home")
