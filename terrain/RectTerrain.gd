extends "res://common/GameObject.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var top_corner:Vector2
var size:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Outline.rect = Rect2(top_corner-Vector2.ONE,size+Vector2.ONE*2)


func setup(game:bool):
	top_corner = Vector2(min(pos1.x,pos2.x),min(pos1.y,pos2.y))
	size = (pos2-pos1).abs()
	var sbody = StaticBody2D.new()
	sbody.position=(pos1+pos2)/2
	add_child(sbody)
	var collision = CollisionShape2D.new()
	sbody.add_child(collision)
	var shape = RectangleShape2D.new()
	shape.extents = size/2
	collision.shape = shape

func _draw():
	draw_rect(Rect2(top_corner,size),Lib.terrain_colour)
