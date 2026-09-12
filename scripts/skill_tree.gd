extends Control

var data = []
@onready var grid = $SkillTreeContainer
@onready var title = %title
@onready var description = %decription
@onready var price2 = %price2
@onready var price = %price

var current_id = 0
var dragging: bool = false
@export var line_color: Color = Color.BLUE_VIOLET
@export var locked_line_color = Color.LIGHT_STEEL_BLUE
@export var line_width: float = 5.0

func load_json_file(file_path: String) -> Variant:
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(data_file.get_as_text())
		data_file.close()
		return parsed_data
	else:
		print("file does not exist!")
		return null

func _load_page() -> void:
	for child in grid.get_children():
		child.queue_free()
		
	data = load_json_file("res://dialogue/skill_tree.json")
	for i in range(data.size()):
		var packed = preload("res://scenes/skill_tree_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.index = i
		storage_ui.name = str(int(data[i]["id"]))
		grid.add_child(storage_ui) 
		storage_ui.load_data(i)
	
	# draw lines
	for i in range(data.size()):
			var item = data[i]
			if "requirements" in item and item["requirements"] is Array:
				var current_id = str(int(item["id"]))
				var current_node = grid.get_node_or_null(current_id)

				for req_id in item["requirements"]:
					var parent_id = int(req_id)
					var parent_node = grid.get_node_or_null(str(parent_id))
					var unlocked = false
					
					if parent_id in Global.skill_tree_unlocked:
						unlocked = true
					if parent_node and current_node:
						create_connection_line(parent_node, current_node, unlocked)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.show_skill.connect(_show_skill)
	_load_page()

func create_connection_line(node_a: Control, node_b: Control, unlocked: bool) -> void:
	var line = Line2D.new()
	line.width = line_width
	if unlocked:
		line.default_color = line_color
	else:
		line.default_color = locked_line_color
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND

	var start_pos = node_a.position + (node_a.size / 2.0)
	var end_pos = node_b.position + (node_b.size / 2.0)

	line.add_point(start_pos)
	line.add_point(end_pos)

	grid.add_child(line)
	grid.move_child(line, 0)
# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_close_pressed() -> void:
	$info.hide()

func _show_skill(data2, bought):
	current_id = int(data2["id"])
	$info.show()
	$info/Buy.show()
	price2.show()
	price.show()
	if data2["name"] == "Locked":
		$info/Buy.hide()
		price2.hide()
		price.hide()
	title.text = data2["name"]
	description.text = data2["desc"]
	price2.text = str(data2["price"])
	if bought:
		price2.hide()
		price.hide()
		$info/Buy.hide()


func _on_buy_pressed() -> void:
	var current_price = data[current_id]["price"]
	if Global.money > current_price:
		Global.skill_tree_unlocked.append(current_id)
		Global.money -= current_price
		_load_page()
