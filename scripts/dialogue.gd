extends Control

var dialogue_data =  {}
var option_selected = 0
var next_dialogue = ""
var current_dialgoue_type = ""
var current_choices = []
var dialgoue_speed = 0.02
var timer = 0
var active_tween: Tween = null
var dialgoue_length = 0
var tween_time = 0

@onready var text_display = $ColorRect/RichTextLabel
@onready var choiceA = $ColorRect/choices/choiceA
@onready var choiceB = $ColorRect/choices/choiceB

func load_json_file(file_path: String) -> Variant:
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(data_file.get_as_text())
		data_file.close()
		return parsed_data
	else:
		print("file does not exist!")
		return null


func get_dialogue_by_id(data:Array, to_find):
	for dialogue in data:
		if dialogue.get("id") == str(to_find):
			return dialogue
	return null


func _display_dialogue(data, id):
	visible = true
	Global.paused = true
	Global.dialogue_ongoing = true
	if data is not Array:
		if data == "find":
			data = dialogue_data
	var dict_display = get_dialogue_by_id(data, id)
	var type = dict_display.get("type")
	choiceA.text = ""
	choiceB.text = ""
	text_display.text = ""
	option_selected = 0
	current_dialgoue_type = type
	if type == "line":
		text_display.text = dict_display.get("text")
		var next = dict_display.get("next_id")
		if next != null:
			next_dialogue = str(next)
		else:
			next_dialogue = ""
		dialgoue_length = len(dict_display.get("text"))
		display_type_dialogue(dialgoue_length)
	elif type == "end":
		current_dialgoue_type = "delete"
		text_display.text = dict_display.get("text")
		next_dialogue = "end"
		dialgoue_length = len(dict_display.get("text"))
		display_type_dialogue(dialgoue_length)
	elif type == "choice":
		var choices = dict_display.get("choices")
		print(choices)
		current_choices = []
		for i in choices:
			current_choices.append(i.get("next_id"))
		if choices.size() == 2:
			choiceA.text = choices[0].get("text")
			choiceB.text = choices[1].get("text")

func display_type_dialogue(length):
	tween_time = length * dialgoue_speed
	text_display.visible_characters = 0
	active_tween = create_tween()
	active_tween.tween_property(text_display, "visible_characters", length, tween_time)
	
func highlight_text():
	if option_selected == 0:
		choiceA.self_modulate = Color.MEDIUM_SPRING_GREEN
		choiceB.self_modulate = Color.WHITE
	elif option_selected == 1:
		choiceB.self_modulate = Color.MEDIUM_SPRING_GREEN
		choiceA.self_modulate = Color.WHITE
				
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.display_dialogue.connect(_display_dialogue)
	dialogue_data = load_json_file("res://dialogue/test.json")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if active_tween and active_tween.is_running():
			active_tween.pause()
			active_tween.custom_step(tween_time)
			return
		if current_dialgoue_type == "line" or current_dialgoue_type == "end": 
			_display_dialogue(dialogue_data,next_dialogue)
		elif current_dialgoue_type == "choice":
			if option_selected < current_choices.size():
				next_dialogue = current_choices[option_selected]
				_display_dialogue(dialogue_data,next_dialogue)		
			else:
				next_dialogue = 0
		elif next_dialogue == "end":
			Global.dialogue_ongoing = false
			visible = false
			Global.paused = false
	
	#highlight stuff
	if Input.is_action_just_pressed("up"):
		option_selected -= 1
		if option_selected < 0:
			option_selected = current_choices.size()-1
	if Input.is_action_just_pressed("down"):
		option_selected += 1
		if option_selected > current_choices.size()-1:
			option_selected = 0
	
	timer += delta
	if timer > dialgoue_speed:
		pass
		timer = 0
	highlight_text()
