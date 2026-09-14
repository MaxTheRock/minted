extends PanelContainer

var index = 0
var data = []
var locked = true

@onready var icon = $TextureRect
@onready var selected = $selected

func load_json_file(file_path: String) -> Variant:
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(data_file.get_as_text())
		data_file.close()
		return parsed_data
	else:
		print("file does not exist!")
		return null


func load_data(index):
	selected.hide()
	if not is_node_ready():
		await ready
	data = load_json_file("res://dialogue/skill_tree.json")
	var current_data = data[index]
	var path = "res://assets/skill_tree/" + str(current_data["image"]) + ".png"
	var requirements = current_data["requirements"]
	var needed = requirements.size()
	var has = 0
	var type = current_data["type"]
	
	for i in requirements:
		if int(i) in Global.skill_tree_unlocked:
			has += 1
		
	if has >= needed:
		icon.texture = load(path)
		locked = false
	else:
		if type == "house":
			icon.texture = load("res://assets/skill_tree/house_locked.png")	
			selected.self_modulate = Color(1.0, 0.839, 0.745, 1.0)
		elif type == "furnature":
			icon.texture = load("res://assets/skill_tree/furnature_locked.png")
			selected.self_modulate = Color(0.243, 0.0, 1.0, 1.0)
		elif type == "community":
			icon.texture = load("res://assets/skill_tree/community_locked.png")
			selected.self_modulate = Color(1.0, 0.118, 0.075, 1.0)
		elif type == "money":
			icon.texture = load("res://assets/skill_tree/money_locked.png")
			selected.self_modulate = Color(0.804, 0.745, 0.0, 1.0)
				
				
	var offset = Vector2(current_data["x_level"]*30,current_data["y_level"]*-80)
	position = position + offset



func _on_button_pressed() -> void:
	
	var type = data[index]["type"]
	if type == "house":
		selected.self_modulate = Color(1.0, 0.839, 0.745, 1.0)
	elif type == "furnature":
		selected.self_modulate = Color(0.243, 0.0, 1.0, 1.0)
	elif type == "community":
		selected.self_modulate = Color(1.0, 0.118, 0.075, 1.0)
	elif type == "money":
		selected.self_modulate = Color(0.804, 0.745, 0.0, 1.0)
		
	if locked:
		SignalBus.show_skill.emit({"name":"Locked","desc":"This item is locked","price":"XXX","id":-1.0},false)
	else:
		var id = int(data[index]["id"])
		if id in Global.skill_tree_unlocked:
			SignalBus.show_skill.emit(data[index],true)
		else:
			SignalBus.show_skill.emit(data[index],false)
	
	selected.show()
	
func hide_selected():
	selected.hide()
