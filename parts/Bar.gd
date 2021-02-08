extends GameObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int, LAYERS_2D_PHYSICS) var layers = 3
export (int, LAYERS_2D_PHYSICS) var mask = 3
export var density = 0.01
export var colour = Color.white
var rbody

# Called when the node enters the scene tree for the first time.
func _ready():
	Lib.attach(pos1,rbody)
	Lib.attach(pos2,rbody)

func setup(game:bool):
	var av = (pos1+pos2)/2
	var d = pos2-pos1
	if game:
		rbody = RigidBody2D.new()
		rbody.mass = d.length()*density
	else:
		rbody = StaticBody2D.new()
	rbody.position=av
	rbody.rotation=Vector2.RIGHT.angle_to(d)
	rbody.collision_layer=layers
	rbody.collision_mask=mask
	add_child(rbody)
	var collision = CollisionShape2D.new()
	rbody.add_child(collision)
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(d.length()/2, 1)
	collision.shape = shape
	set_process(game)

func _process(delta):
	update()
func _draw():
	if rbody:
		var d = pos1.distance_to(pos2)*0.5
		draw_line(rbody.to_global(Vector2.LEFT*d),rbody.to_global(Vector2.RIGHT*d),colour,2,true)
	else:
		draw_line(pos1,pos2,colour,2,true)
