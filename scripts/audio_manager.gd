extends Node

@onready var music_player := AudioStreamPlayer.new()
@onready var sfx_player := AudioStreamPlayer.new()
@onready var click_player := AudioStreamPlayer.new()
var current_active_channel: String = "none"

const background_menu_music = preload("res://audio/background_menu.mp3")
const the_big_mint = preload("res://audio/the_big_mint.mp3")
const evil_pulsation = preload("res://audio/evil_pulsation.mp3")
const jungle = preload("res://audio/jungle.mp3")
const smooth_jazz_1 = preload("res://audio/smooth_jazz_1.mp3")
const three_jelly = preload("res://audio/three_jelly.mp3")
const red_nose_pop = preload("res://audio/red_nose_pop.mp3")
const audio_static = preload("res://audio/static.mp3")

var radio_a = [background_menu_music, smooth_jazz_1,red_nose_pop]
var radio_b = [three_jelly, the_big_mint, jungle]

var last_played_song: AudioStream = null

func _ready() -> void:
	add_child(music_player)
	add_child(sfx_player)
	add_child(click_player)

	music_player.bus = "Music"
	sfx_player.bus = "SFX"
	click_player.bus = "SFX"

	music_player.volume_db = Global.music_volume
	sfx_player.volume_db = Global.sfx_volume
	click_player.stream = preload("res://audio/SFX/click.wav")
	music_player.finished.connect(_on_music_player_finished)
	get_tree().node_added.connect(_on_node_added)

func _on_music_player_finished() -> void:
	if Global.radio_on and current_active_channel != "none":
		call_deferred("play_radio_station", current_active_channel)
		return 
			
	call_deferred("eject")
	
func play_music(music: AudioStream) -> void:
	var mp3_stream = music as AudioStreamMP3
	if mp3_stream:
		if music == audio_static:
			mp3_stream.loop = true
		else:
			mp3_stream.loop = false

	if music_player.stream == music and music_player.playing:
		return
		
	music_player.stream = music
	music_player.play()

func pause(toggle) -> void:
	music_player.stream_paused = toggle

func play_sfx(sound: AudioStream) -> void:
	sfx_player.stream = sound
	sfx_player.play()

func eject():
	var mp3_stream = background_menu_music as AudioStreamMP3
	if mp3_stream:
		mp3_stream.loop = false
		
	music_player.stream = background_menu_music
	music_player.play()

func play_click() -> void:
	click_player.stop()
	click_player.play()

func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		node.pressed.connect(play_click)

func play_radio_station(channel: String) -> void:
	current_active_channel = channel
	
	if channel == "A":
		var available_songs = radio_a.filter(func(song): return song != last_played_song)

		if available_songs.is_empty(): 
			available_songs = radio_a
			
		var random_song = available_songs.pick_random()
		last_played_song = random_song 
		play_music(random_song)

		
	elif channel == "B":
		var available_songs = radio_b.filter(func(song): return song != last_played_song)
		
		if available_songs.is_empty(): 
			available_songs = radio_b
			
		var random_song = available_songs.pick_random()
		last_played_song = random_song
		play_music(random_song)
		
	else:
		last_played_song = null 
		play_music(audio_static)
		
func _radio_power():
	eject()
