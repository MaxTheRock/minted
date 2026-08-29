extends Control

@onready var inventory_grid = $inventory/ScrollContainer/GridContainer
@onready var cd_player = $cd_player
@onready var now_playing_text = $now_playing_text

var bounce_time = 0.0



func _ready() -> void:
	Global.pause_toggled.connect(_on_global_pause_toggled)
	Global.eject.connect(_on_global_eject)
	Inventory.current_ui_type = "cd_player"

	for i in range(Inventory.player_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		inventory_grid.add_child(storage_ui)

func _process(delta: float) -> void:
	if Global.now_playing != "":
		if Global.cd_paused:
			now_playing_text.text = "Now Playing: " + Global.now_playing + " (paused)"
		else:
			now_playing_text.text = "Now Playing: " + Global.now_playing
			bounce_time += delta * 6.0
			var bounce = sin(bounce_time) * 0.2
			cd_player.scale = Vector2(
				10.0 + bounce,
				10.0 - bounce * 0.5
			)
		
func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shelf.tscn")



func _on_pause_pressed() -> void:
	if not Global.radio_on:
		Global.cd_paused = not Global.cd_paused
		Global.pause_toggled.emit(Global.cd_paused)
		const background_menu_music = preload("res://audio/background_menu.mp3")
		if AudioManager.music_player.stream == background_menu_music and Inventory.cd_inventory.size() == 1:
			var type = Inventory.cd_inventory[0]["type"]
			if type == "the_big_mint":
				AudioManager.play_music(AudioManager.the_big_mint)
			elif type == "smooth_jazz_1":
				AudioManager.play_music(AudioManager.smooth_jazz_1)
			elif type == "evil_pulsation":
				AudioManager.play_music(AudioManager.evil_pulsation)
			elif type == "jungle":
				AudioManager.play_music(AudioManager.jungle)
			elif type == "three_jelly":
				AudioManager.play_music(AudioManager.three_jelly)
			elif type == "red_nose_pop":
				AudioManager.play_music(AudioManager.red_nose_pop)
	else:
		$radio_warning.show()


func _on_eject_pressed() -> void:
	Global.now_playing = ""
	Global.eject.emit()
	
func _on_global_pause_toggled(is_paused: bool) -> void:	
	AudioManager.pause(is_paused)

 
func _on_global_eject() -> void:
	if Inventory.player_inventory.size() < 2:
		AudioManager.eject()
		Inventory.transfer_item(Inventory.cd_inventory,
		Inventory.player_inventory, 0)
		get_tree().reload_current_scene()
	else:
		print("Player Inventory full!")
