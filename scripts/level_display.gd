extends MarginContainer

@onready var level_text = $Number/Label
@onready var sprite = $Level_Design/AnimatedSprite2D
@onready var progress_bar = $Level_Design/ProgressBar

var level = level_calculator(Global.xp)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	level = level_calculator(Global.xp)
	level_text.text = str(level)
	progress_bar.value = percentage_from_next(Global.xp)
	if level >= 1 and level <=9:
		sprite.frame=0
	elif level >= 10 and level <=24:
		sprite.frame=1
	elif level >= 25 and level <=49:
		sprite.frame=2
	elif level >= 50 and level <=74:
		sprite.frame=3
	elif level >= 75 and level <=99:
		sprite.frame=4
	elif level >= 100 and level <=149:
		sprite.frame=5
	elif level >= 150 and level <=199:
		sprite.frame=6
	elif level >= 200 and level <=299:
		sprite.frame=7
	elif level >= 300 and level <=399:
		sprite.frame=8
	elif level >= 400 and level <=499:
		sprite.frame=9
	elif level >= 500 and level <=599:
		sprite.frame=10
	elif level >= 600 and level <=699:
		sprite.frame=11
	elif level >= 700 and level <=799:
		sprite.frame=12
	elif level >= 800 and level <=899:
		sprite.frame=13
	elif level >= 900 and level <=999:
		sprite.frame=14
	elif level >= 1000:
		sprite.frame=15

func level_calculator(xp) -> int:
	# got chatgpt to make this formula so don't ask
	return max(1, int(pow(xp / 1000.0, 1.0 / 2.8)) + 1)
	
func percentage_from_next(xp: int) -> float:
	var level = level_calculator(xp)
	var current_level_xp = int(1000.0 * pow(level - 1, 2.8))
	var next_level_xp = int(1000.0 * pow(level, 2.8))
	return float(xp - current_level_xp) / float(next_level_xp - current_level_xp) * 100.0100
