extends Control
 
@onready var bidding_display =  $Bidding/ScrollContainer/GridContainer
func _build_page():
	Inventory.current_ui_type = "display_bidding"
	for child in bidding_display.get_children():
		bidding_display.remove_child(child)
		child.queue_free()
	for i in range(Inventory.bidding_items.size()):
		var packed = preload("res://scenes/bidding_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.item_index = i
		bidding_display.add_child(storage_ui)
 
 
func _on_tree_entered() -> void:
	call_deferred("_build_page")
