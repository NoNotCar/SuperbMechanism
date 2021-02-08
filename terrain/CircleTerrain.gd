extends "res://common/GameObject.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var radius:float

func _ready():
	$Outline.radius = radius+1

func setup(game:bool):
	position=pos1
	radius=pos1.distance_to(pos2)
	if radius<=1:
		radius=8.5
	var body = StaticBody2D.new()
	add_child(body)
	var collison = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius=radius
	collison.shape=shape
	body.add_child(collison)

func _draw():
	draw_circle(Vector2.ZERO,radius,Lib.terrain_colour)
