extends "res://common/GameObject.gd"

var is_game = false
var body:PhysicsBody2D
var torquing = []
export var target_speed = 0.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	target_speed*=TAU
	if is_game:
		body = $RigidBody2D
		var s = $Sprite
		remove_child(s)
		$RigidBody2D.add_child(s)
	else:
		$RigidBody2D.queue_free()
	for v in [Vector2.ZERO]+Lib.around:
		Lib.attach(position+v*8,body)
	set_physics_process(is_game and target_speed)
func setup(game:bool):
	position=pos2
	is_game = game
	if not game:
		body = StaticBody2D.new()
		add_child(body)
		var shape = CollisionShape2D.new()
		var circle = CircleShape2D.new()
		circle.radius=9
		shape.shape=circle
		body.add_child(shape)

func _physics_process(delta):
	if not torquing:
		var axle = Lib.grab_node(position)
		if axle:
			for b in axle.attached:
				if b is RigidBody2D and b!=$RigidBody2D:
					torquing.append(b)
		if not torquing:
			set_physics_process(false)
			return
	var self_torque = 0.0
	var f = delta*1000/torquing.size()
	for t in torquing:
		var d = (t.angular_velocity - $RigidBody2D.angular_velocity - target_speed)*f
		t.apply_torque_impulse(-d)
		self_torque+=d
	$RigidBody2D.apply_torque_impulse(self_torque)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
