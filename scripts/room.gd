extends Node2D

@onready var grid = $Hotbar/inventory/ScrollContainer/GridContainer
@onready var player = $player/Player
@onready var sleep_bar = $left_bar/sleep/sleep_bar
@onready var time_ui = $left_bar/sleep/timer/Time
@onready var left_bar = $left_bar

var left = true

func _ready() -> void:
	Inventory.current_ui_type = "player"
	player.global_position.x = Global.player_saved_x
	player.global_position.y = Global.player_saved_y
	if Global.first_room and not Global.skip_dialogue:
		Global.dialogue_ongoing = true
		await get_tree().create_timer(1.0).timeout
		SignalBus.display_dialogue.emit("find",0)

	for i in range(Inventory.player_inventory.size()):
		var packed = preload("res://scenes/item_ui.tscn")
		var storage_ui = packed.instantiate()
		storage_ui.inventory_index = i
		grid.add_child(storage_ui)

func _process(float) -> void:
	sleep_bar.value = Global.sleep
	time_ui.text = Global.get_time_text()
	Global.player_saved_x = player.global_position.x
	Global.player_saved_y = player.global_position.y
	
var tween: Tween
@onready var start_position: Vector2 = left_bar.position

func _on_slide_pressed() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	left = !left
	$left_bar/slide.rotation_degrees += 180
	if left:
		
		var target_position = start_position 

		tween.tween_property(left_bar, "position", target_position, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)
	else:
		var target_position = start_position + Vector2(300, 0)

		tween.tween_property(left_bar, "position", target_position, 1.0) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)
		
