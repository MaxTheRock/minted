extends Node2D

@onready var c_walls: CollisionPolygon2D = $collisions/walls
@onready var c_wardrobe: CollisionPolygon2D = $collisions/wardrobe
@onready var c_shelf: CollisionPolygon2D = $collisions/shelf
@onready var c_desk: CollisionPolygon2D = $collisions/desk
@onready var c_bed: CollisionPolygon2D = $collisions/bed

func _ready() -> void:
	c_walls.disabled = false
	c_wardrobe.disabled = false
	c_shelf.disabled = false
	c_desk.disabled = false
	c_bed.disabled = false


func _process(delta: float) -> void:
	if Global.outside:
		c_walls.disabled = true
		c_wardrobe.disabled = true
		c_shelf.disabled = true
		c_desk.disabled = true
		c_bed.disabled = true
	else:
		c_walls.disabled = false
		c_wardrobe.disabled = false
		c_shelf.disabled = false
		c_desk.disabled = false
		c_bed.disabled = false
