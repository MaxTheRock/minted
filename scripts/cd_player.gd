extends Control

@onready var inventory_grid = $inventory/ScrollContainer/GridContainer
@onready var cd_player = $cd_player
@onready var now_playing_text = $now_playing_text

var bounce_time = 0.0
var paused = false


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
		if paused:
			now_playing_text.text = "Now Playing: " + Global.now_playing + " (Paused)"
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
	paused = not paused
	Global.pause_toggled.emit(paused)



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
