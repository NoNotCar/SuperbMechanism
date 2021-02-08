extends "res://common/GameObject.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var poly = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Polygon2D.color=Lib.terrain_colour
	$Outline.color=Lib.darker_terrain


func setup(game:bool):
	poly = Lib.to_ramp(pos1,pos2)
	var center = (pos1+pos2+poly[2])/3
	$StaticBody2D/CollisionPolygon2D.polygon=poly
	$Polygon2D.polygon=poly
	var outline = []
	for n in poly.size():
		var p1 = poly[n]
		var p2 = poly[(n+1)%3]
		var d = (p2-p1)
		var perp = Vector2(-d.y,d.x).normalized()
		if perp.dot(p1-center)<0:
			perp*=-1
		outline.append(p1+perp)
		outline.append(p2+perp)
	$Outline.polygon=outline
