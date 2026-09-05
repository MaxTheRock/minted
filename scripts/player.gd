extends CharacterBody2D

const SPEED = 250.0
var moveDir = Vector2(0,0)

@onready var sprite= $Player
var most_recent_dir = ""

func _physics_process(delta: float) -> void:
	movement(delta)

func movement(d):
	if not Global.dialogue_ongoing:
		if Input.is_action_pressed("right"):
			moveDir.x = 1
			sprite.play("right")
			most_recent_dir = "right"
		elif Input.is_action_pressed("left"):
			moveDir.x = -1
			sprite.play("left")
			most_recent_dir = "left"
		elif Input.is_action_pressed("up"):
			moveDir.y = -1
			sprite.play("walk_up")
			most_recent_dir = "up"
		elif Input.is_action_pressed("down"):
			moveDir.y = 1
			sprite.play("walk_down")
			most_recent_dir = "down"
		else:
			sprite.play(most_recent_dir)
			
		if !Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
			moveDir.x = 0
		if !Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
			moveDir.y = 0
		
		var target_velocity = moveDir.normalized() * SPEED
		var collision = move_and_collide(target_velocity * d)
		
		if collision:
			var remainder = collision.get_remainder()
			var slide_vector = remainder.slide(collision.get_normal())
			if slide_vector != Vector2.ZERO:
				slide_vector = slide_vector.normalized() * remainder.length() * 0.7
			
			move_and_collide(slide_vector)
