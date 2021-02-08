extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var radius:float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	draw_circle(Vector2.ZERO,radius,Lib.darker_terrain)
