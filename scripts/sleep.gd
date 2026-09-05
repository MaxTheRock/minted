extends Control

@onready var time_ui = $sleep/timer/Time
@onready var slider = $HSlider
@onready var sleep_bar = $sleep/sleep_bar
@onready var sleep_needed = $sleep/sleep_needed
@onready var sleep_gained = $sleep/sleep_gained
var sleep_duration = 8
@onready var sleep_text = $Sleep_duration
@onready var not_tired = $not_tired
@onready var fade_overlay = $PanelContainer2
var sleep_needed_int = 0
var sleep_gained_int = 0

var sleep_name = "Sleep"
var sleep_vals = [8,10,12,14,16,18,20,22,25,28,31,35,41,46,50]
var sleep_amounts = [20,25,30,33,36,40,45,48,50,52,54,56,60,64,67,70]

func _ready() -> void:
	var original_image = Image.load_from_file("res://assets/os/icons/sleep.png")	
	original_image.resize(32, 32, Image.INTERPOLATE_LANCZOS)
	sleep_text.grow_horizontal = Control.GROW_DIRECTION_BOTH
	var small_tex = ImageTexture.create_from_image(original_image)
	
	# Apply the resized texture to the theme overrides
	slider.add_theme_icon_override("grabber", small_tex)
	slider.add_theme_icon_override("grabber_highlight", small_tex)
	sleep_needed.value = 0
	sleep_bar.value = Global.sleep
	get_sleep_text(8.0)
	_on_h_slider_value_changed(8)
	
func _process(delta:float) -> void:
	sleep_bar.value = Global.sleep
	time_ui.text = Global.get_time_text()
	sleep_needed_int = sleep_vals[slider.value-2]
	if Global.hour >= 6 and Global.hour <= 10:
		sleep_needed_int += 20
	elif Global.hour >= 7 and Global.hour <= 18:
		sleep_needed_int += 30
	elif Global.hour >= 18 and Global.hour <= 22:
		sleep_needed_int += 10
	sleep_needed.value = sleep_needed_int
	sleep_gained.value = sleep_gained_int
	time_ui.text = Global.get_time_text()
	
func get_sleep_text(time):
	var format_string = "(%s hours)"
	sleep_text.text = sleep_name + " " + format_string % time
	$text2.text = "Gaining " + str(sleep_gained_int) +"% sleep"
	
func _on_h_slider_value_changed(value: float) -> void:
	if slider.value == 16:
		sleep_name = "Hibernate"
	elif slider.value >= 10:
		sleep_name = "Deep Sleep"
	elif slider.value >= 6:
		sleep_name = "Sleep"
	elif slider.value >= 4:
		sleep_name = "Rest"
	else:
		sleep_name = "Nap"
	 
	sleep_needed.value = sleep_needed_int
	sleep_needed_int = sleep_vals[slider.value-2]
	sleep_gained_int = sleep_amounts[slider.value-2]
	
	if Global.hour >= 6 and Global.hour <= 10:
		sleep_needed_int += 20
	elif Global.hour >= 7 and Global.hour <= 18:
		sleep_needed_int += 30
	elif Global.hour >= 18 and Global.hour <= 22:
		sleep_needed_int += 10
	get_sleep_text(slider.value)

func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/room.tscn")

func fade_to_black(duration: float = 1.0) -> void:
	fade_overlay.show() 
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate", Color(1, 1, 1, 1), duration)
	await tween.finished

func fade_from_black(duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate", Color(1, 1, 1, 0), duration)
	await tween.finished
	fade_overlay.hide() 
		
func _on_sleep_button_pressed() -> void:
	if float(sleep_needed_int) + Global.sleep > 100:
		not_tired.text = "Not Tired Enough..."
	else:
		Global.current_interactable = null
		Global.dialogue_ongoing = true
		AudioManager.pause(true)
		fade_overlay.modulate = Color(1, 1, 1, 0)
		await fade_to_black(1.5)
		
		$dialogue.sleep_mode()
		$sleep_screen.show()		
		var sleep_tween = create_tween()
		$sleep_screen.fade_out_black_screen()
		sleep_tween.tween_property($sleep_screen, "modulate", Color(1, 1, 1, 1), 2.0)
		await sleep_tween.finished
		
		SignalBus.display_dialogue.emit("find", 9)
		await SignalBus.dialogue_finished

		Global.sleep += min(float(sleep_gained_int), 100)
		Global.hour += int(slider.value)
		Global.time_mins += int(slider.value) * 60
		Global.hour = Global.hour % 24
		get_sleep_text(8.0)
		_on_h_slider_value_changed(8)
		
		# Clean up and exit
		$sleep_screen.hide()
		AudioManager.pause(false)
		get_tree().change_scene_to_file("res://scenes/room.tscn")
		Global.dialogue_ongoing = false
