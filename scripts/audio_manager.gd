extends Node

@onready var music_player := AudioStreamPlayer.new()
@onready var sfx_player := AudioStreamPlayer.new()

const background_menu_music = preload("res://audio/background_menu.mp3")
const the_big_mint = preload("res://audio/the_big_mint.mp3")
const evil_pulsation = preload("res://audio/evil_pulsation.mp3")
const jungle = preload("res://audio/jungle.mp3")
const smooth_jazz_1 = preload("res://audio/smooth_jazz_1.mp3")
const three_jelly = preload("res://audio/three_jelly.mp3")

func _ready() -> void:
	add_child(music_player)
	add_child(sfx_player)

	music_player.volume_db = Global.music_volume
	sfx_player.volume_db = Global.sfx_volume


func play_music(music: AudioStream) -> void:
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
	music_player.stream = background_menu_music
	music_player.play()
