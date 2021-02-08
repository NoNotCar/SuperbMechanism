extends "res://common/GameObject.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var rect:Rect2
var body: PhysicsBody2D
const COLOUR = Color8(234,50,60)
const diag = [Vector2(-1,1),Vector2(-1,-1),Vector2(1,-1),Vector2(1,1)]
# Called when the node enters the scene tree for the first time.
func _ready():
	for v in [Vector2.ZERO]+diag:
		Lib.attach(body.position+rect.size/2*v,body)
	if body is RigidBody2D:
		body.add_to_group("Targets")
	set_process(body is RigidBody2D)


func setup(game:bool):
	rect = Lib.to_rect(pos1,pos2)
	if game:
		body = RigidBody2D.new()
		body.mass = rect.size.x*rect.size.y/254.0
	else:
		body = StaticBody2D.new()
	body.position=rect.position+rect.size/2
	body.collision_layer=12
	body.collision_mask=13
	add_child(body)
	var collison = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.extents=rect.size/2
	collison.shape=shape
	body.add_child(collison)

func _process(delta):
	update()

func _draw():
	var hs = rect.size/2
	var poly = []
	for d in diag:
		poly.append(body.to_global(d*hs))
	draw_colored_polygon(poly,COLOUR)
	draw_multiline(poly,COLOUR.darkened(0.3),1,true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
