extends GameObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const F = 400.0
var body:PhysicsBody2D
var raycast:RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for v in [Vector2.LEFT,Vector2.RIGHT]:
		Lib.attach(position+v.rotated(rotation)*7,body)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func setup(game:bool):
	position=pos1
	rotation=Vector2.UP.angle_to(pos2-pos1)
	if game:
		body = RigidBody2D.new()
		$AnimatedSprite.playing=true
	else:
		body = StaticBody2D.new()
		set_physics_process(false)
	body.layers=4
	body.collision_mask=5
	raycast=$RayCast2D
	add_child(body)
	for n in [$RayCast2D,$Shape,$Shape2,$AnimatedSprite]:
		remove_child(n)
		body.add_child(n)
	
func _physics_process(delta):
	var ground_effect = 0.5
	if raycast.is_colliding():
		var target = raycast.get_collider()
		var d = raycast.get_collision_point()-body.global_position
		var ge = (64-d.length())/64
		ground_effect+=ge/2
		if target is RigidBody2D:
			target.apply_impulse(raycast.get_collision_point()-target.global_position,d.normalized()*(ge*F*delta))
	if body is RigidBody2D:
		body.apply_central_impulse(Vector2.UP.rotated(body.global_rotation)*F*ground_effect*delta)
