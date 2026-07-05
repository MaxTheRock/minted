extends Control

@onready var blank = $BLANK
@onready var item = $ITEM
@onready var itemz = $ITEM/item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.shelf_inventory.size() >= 1:
		item.show()
		blank.hide()
	else:
		blank.show()
		item.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shelf_item_select.tscn")


func _on_remove_pressed() -> void:
	Global.shelf_inventory.erase(itemz.get_data())
	get_tree().change_scene_to_file("res://scenes/shelf.tscn")
	Global.inventory.append(itemz.get_data())
