extends "res://common/GameObject.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var radius:float
var body: PhysicsBody2D
const COLOUR = Color8(255,200,37)
var offset:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	Lib.attach(pos2,body)
	set_process(body is RigidBody2D)


func setup(game:bool):
	radius=pos1.distance_to(pos2)
	offset = pos2-pos1
	if game:
		body = RigidBody2D.new()
		body.mass = pow(radius/9,2)
		body.gravity_scale=-0.5
	else:
		body = StaticBody2D.new()
	body.position=pos1
	body.collision_layer=4
	body.collision_mask=5
	add_child(body)
	var collison = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius=radius
	collison.shape=shape
	body.add_child(collison)

func _process(delta):
	update()

func get_dink():
	var poly = []
	for ad in [[0.3,0.85],[0.6,0.85],[0.6,0.75],[0.3,0.75]]:
		poly.append(body.position+Vector2.UP.rotated(ad[0])*radius*ad[1])
	return poly
func get_knot():
	var poly = []
	var angoff = Vector2.UP.angle_to(offset)
	for ad in [[-0.05,1],[-0.1,1.2],[0.1,1.2],[0.05,1]]:
		poly.append(body.position+Vector2.UP.rotated(ad[0]+angoff+body.rotation)*radius*ad[1])
	return poly
func _draw():
	draw_colored_polygon(get_knot(),COLOUR.darkened(0.5))
	draw_circle(body.position,radius,COLOUR)
	draw_arc(body.position,radius,0,TAU,32,COLOUR.darkened(0.3),1,true)
	draw_colored_polygon(get_dink(),Color(1,1,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
