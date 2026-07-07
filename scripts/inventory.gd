extends Node

var current_ui_type = "market"
var player_inventory: Array = []
var wardrobe_inventory: Array = []
var shelf_inventory: Array = []
var cd_inventory: Array = []
var display_item: Array = []
var actual_selling: Array = []
var player_selling: Array = []
# global signal
signal inventories_changed


func transfer_item(from_array: Array, to_array: Array, from_index: int) -> bool:
	
	if from_index < 0 or from_index >= from_array.size() or from_array[from_index] == null:
		return false
		
	var item_to_move = from_array[from_index]
	to_array.append(item_to_move)
	from_array.pop_at(from_index)
	
	inventories_changed.emit()
	return true
