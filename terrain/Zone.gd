extends "res://common/GameObject.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rect: Rect2
export var colour = Color8(0,152,220,128)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(game:bool):
	rect = Lib.to_rect(pos1,pos2)
	$Area2D.position=rect.position+rect.size/2
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.extents=rect.size/2
	collision.shape=shape
	$Area2D.add_child(collision)
	$Sprite.position=rect.position+Vector2.ONE+$Sprite.get_rect().size/2

func _draw():
	draw_rect(rect,colour)
