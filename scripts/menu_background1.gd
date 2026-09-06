extends Control

@export var speed: float = 1000.0
@export var spacing: float = 1500.0

@onready var template: TextureRect = $TextureRect

var textures: Array[TextureRect] = []

@onready var wheel1: AnimatedSprite2D = $Sprite2D/wheel1
@onready var wheel2: AnimatedSprite2D = $Sprite2D/wheel2


func _ready() -> void:
	template.visible = false
	$AnimationPlayer.play("moving car")
	wheel1.play("default")
	wheel2.play("default")

	spawn_texture(-template.size.x * 2)
	spawn_texture(-template.size.x)
	spawn_texture(0)


func _process(delta: float) -> void:
	for texture in textures:
		texture.position.x += speed * delta

	for texture in textures.duplicate():
		if texture.position.x > size.x:
			textures.erase(texture)
			texture.queue_free()

	if textures.is_empty():
		spawn_texture(-template.size.x)
		return

	var leftmost: TextureRect = textures[0]

	for texture in textures:
		if texture.position.x < leftmost.position.x:
			leftmost = texture

	if leftmost.position.x > -template.size.x:
		var new_x = leftmost.position.x - template.size.x - spacing
		spawn_texture(new_x)


func spawn_texture(x: float) -> void:
	var new_texture := template.duplicate() as TextureRect
	new_texture.visible = true
	new_texture.position.x = x
	add_child(new_texture)
	textures.append(new_texture)
