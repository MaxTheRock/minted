extends Control

@onready var radio = $radio
@onready var frequency_label = $frequency_label

var fade_tween: Tween

var current_text = ""
const RADIO_A = 125
const RADIO_B = 165
const leniance = 4
var text_shift = 0.3	
var index = 0
var lock_timer = 0.8
var locked = false
var bounce_time = 0.0

signal play_radio(channel)
signal power_off

func _ready() -> void:
	frequency_label.modulate.a = 0.0 
	self.power_off.connect(AudioManager._radio_power)
	self.play_radio.connect(AudioManager.play_radio_station)
	$frequency.value = Global.frequency
	if Global.radio_on:
		Global.cd_paused = true
		radio.play("on")
		radio.frame = 3
		radio_text(Global.radio_playing)
		locked = true
	
func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shelf.tscn")

func _on_power_pressed() -> void:
	Global.radio_on = !Global.radio_on
	if Global.radio_on:
		radio.play("on")
		if Global.radio_playing == "none":
			play_radio.emit(Global.radio_playing)
		radio_text(Global.radio_playing)
	else:
		radio.play("off")
		power_off.emit()
		if fade_tween:
			fade_tween.kill()
		frequency_label.modulate.a = 0.0

func _on_frequency_value_changed(value: float) -> void:
	locked = false
	lock_timer = 0.8
	frequency_label.text = str(value) + "MHZ"
	current_text =  str(value) + "MHZ"
	Global.frequency = value
	if Global.frequency + leniance >= RADIO_A and Global.frequency - leniance <= RADIO_A:
		Global.radio_playing = "A"
	elif Global.frequency + leniance >= RADIO_B and Global.frequency - leniance <= RADIO_B:
		Global.radio_playing = "B"
	else:
		Global.radio_playing = "none"
	if Global.radio_on and radio.frame >= 3: 
		frequency_label.modulate.a = 1.0
		
		if fade_tween:
			fade_tween.kill()
			

		fade_tween = create_tween()
		fade_tween.tween_interval(0.5)
		fade_tween.tween_property(frequency_label, "modulate:a", 0.0, 1.0)
		fade_tween.tween_callback(radio_text.bind(Global.radio_playing))
	else:
		frequency_label.modulate.a = 0.0

func radio_text(radio_playing):
	if radio_playing == "A":
		frequency_label.text = "RADIO A"
		current_text = "RADIO A"
		frequency_label.modulate.a = 1.0
	elif radio_playing == "B":
		frequency_label.text = "RADIO B"
		current_text = "RADIO B"
		frequency_label.modulate.a = 1.0
	else:
		current_text = "radio not found"
		frequency_label.modulate.a = 1.0
		


func _process(delta: float) -> void:
	text_shift -= delta
	if text_shift <= 0 and len(current_text) > 8:
		text_shift = 0.3
		var looped_text = current_text + "    "
		var double_text = looped_text + looped_text
		frequency_label.text = double_text.substr(index, 8)
		index += 1
		if index >= looped_text.length():
			index = 0
	if Global.radio_playing != "none" and Global.radio_on:
		bounce_time += delta * 6.0
		var bounce = sin(bounce_time) * 0.2
		radio.scale = Vector2(
			10.0 + bounce,
			10.0 - bounce * 0.5
		)
	if Global.radio_on:
		lock_timer -= delta
	else:
		lock_timer = 0.8
	if lock_timer <= 0 and not locked:
		locked = true
		Global.cd_paused = true
		play_radio.emit(Global.radio_playing)
