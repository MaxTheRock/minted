extends SubViewport

@onready var player = $"../../../player/Player"
@onready var camera2d = $Camera2D
@onready var real_locker = $"../../../Locker"
@onready var real_home = $"../../../Control/door_area/CollisionShape2D"
@onready var real_bank = $"../../../bank"
@onready var player_icon = $"../marker"
@onready var locker_icon = $"../locker_icon"
@onready var home_icon = $"../home_icon"
@onready var bank_icon = $"../bank_icon"

@export var minimap_scale := 0.1
@export var minimap_offset := Vector2(0, 67)


func _ready() -> void:
	world_2d = get_tree().root.world_2d


func _process(_delta: float) -> void:
	camera2d.position = player.global_position
	
	
	player_icon.position = player.global_position * minimap_scale + minimap_offset
	home_icon.position = real_home.global_position * minimap_scale + minimap_offset + Vector2(0, 3)
	locker_icon.position = real_locker.global_position * minimap_scale + minimap_offset
	bank_icon.position = real_bank.global_position * minimap_scale + minimap_offset + Vector2(70, 35)
