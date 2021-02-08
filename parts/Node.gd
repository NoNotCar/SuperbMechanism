extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var attached = []
var p_offset:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_body(r:PhysicsBody2D):
	if r is RigidBody2D:
		for a in attached:
			var p = PinJoint2D.new()
			p.position=r.to_local(position)
			p.node_a=r.get_path()
			p.node_b=a.get_path()
			p.softness=0.1
			r.add_child(p)
	if not attached:
		p_offset = r.to_local(position)
		if r is StaticBody2D:
			set_process(false)
	attached.append(r)
func _process(delta):
	if attached:
		position=attached[0].to_global(p_offset)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
