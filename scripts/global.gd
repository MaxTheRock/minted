extends Node

var money: float = 50.00
var xp: int = 0
var storage_capacity: int = 10
var inWardrobe: bool = false
var inShelf: bool = false
var now_playing: String = ""
var music_volume: int = -10
var sfx_volume: int = -5
var camera_quality = "Good"
var refreshProgress = 100
var player_saved_x = 0
var player_saved_y = 0
var first_room = true
var dialogue_ongoing = false
signal pause_toggled(is_paused: bool)
signal eject
signal create_mail

# --- CLOCK --- #
var min = 0
var hour = 6
var day = 1
var month = 7
var year = 2026
var time_mins = 0

var clock_timer = 0.0
var paused = false
var skip_dialogue = true
var no_sleep = true

var sleep = 90
var CLOCK_SPEED = 0.01 # ---> The lower, the faster jsuk rohan for testing
const SPEED_MULT = 1  # just makes time even faster, default to 1.
const months_31 = [1,3,5,7,8,10,12]
const months_30 = [4,6,9,11]
const REFRESHTIME: float = 6*60 # 6 in game hours

func _process(delta):
	clock_timer += delta
	if clock_timer >= CLOCK_SPEED and not paused and not dialogue_ongoing:
		refreshProgress += 100/REFRESHTIME
		clock_timer -= CLOCK_SPEED
		new_time_calc(SPEED_MULT)
	elif dialogue_ongoing or paused:
		clock_timer = 0
		
func new_time_calc(min_added: int) -> void:
	min += min_added 
	time_mins += min_added 
	if not no_sleep:
		sleep -= float(min_added) / 28
		if sleep <= 10:
			sleep += float(min_added) / 60 # 50% slower
		elif sleep <= 40:
			sleep += float(min_added) / 120 # 25% slower
		
	if min >= 60:
		min -= 60
		hour += 1

	if hour >= 24:
		hour -= 24
		day += 1

		var days_in_month = calc_days_in_month(month, year)

		if day > days_in_month:
			day = 1
			month += 1

			if month > 12:
				month = 1
				year += 1

func get_time_text() -> String:
	return format_time(hour) + ":" + format_time(min)

func get_date_text() -> String:
	return format_time(day) + "/" + format_time(month) + "/" + format_time(year)


func calc_days_in_month(month, year) -> int:
	if month in months_31:
		return 31
	elif month in months_30:
		return 30
	elif is_leap_year(year):
		return 29
	else:
		return 28

func is_leap_year(year) -> bool:
	return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)

func format_time(time) -> String:
	var t = str(time)
	if t.length() == 1:
		t = "0" + t
	return t

# --- END Clock --- #

func name_generator():
	var first_names_m = ["oliver","tom","max","arthur","rohan","william","kai","jerry","mac","gabe","rick","peter","chris"]
	var first_names_f = ["olivia","liz","tal","sophie","maya","margaret","eileen","noelle","susie","lois"]
	
	var prefixes = ["green","awesome","webbed","death","crazy","pink","wizardy","lucky","spiky"]
	var gender= randi_range(1,2)
	if gender == 1:
		return prefixes.pick_random() + first_names_m.pick_random() + str(randi_range(1,100))
	if gender == 2:
		return prefixes.pick_random() + first_names_f.pick_random() + str(randi_range(1,100))

func begin():
	pass	
