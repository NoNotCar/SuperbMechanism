extends "res://common/GameObject.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var radius:float
var body: PhysicsBody2D
const COLOUR = Color8(234,50,60)

# Called when the node enters the scene tree for the first time.
func _ready():
	for v in [Vector2.ZERO]+Lib.around:
		Lib.attach(body.position+v*(radius-0.5),body)
	if body is RigidBody2D:
		body.add_to_group("Targets")
	set_process(body is RigidBody2D)


func setup(game:bool):
	radius=pos1.distance_to(pos2)
	if radius<=1:
		radius=8.5
	if game:
		body = RigidBody2D.new()
		body.mass = pow(radius/9,2)
	else:
		body = StaticBody2D.new()
	body.position=pos1
	body.collision_layer=12
	body.collision_mask=13
	add_child(body)
	var collison = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius=radius
	collison.shape=shape
	body.add_child(collison)

func _process(delta):
	update()

func _draw():
	draw_circle(body.position,radius,COLOUR)
	draw_arc(body.position,radius,0,TAU,32,COLOUR.darkened(0.3),1,true)
