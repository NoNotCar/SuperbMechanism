extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var selection
const input = preload("res://components/io/Input.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("connecc_selecc")
func _process(delta):
	global_position=get_global_mouse_position().snapped(Vector2(24,24))
func _input(event):
	if visible:
		if event.is_action_pressed("place") and not $Obstruction.get_overlapping_bodies():
			if abs(position.x)<=get_parent().size*24 and abs(position.y)<=get_parent().size*24:
				var n=selection.instance()
				n.position=position
				n.rotation=rotation
				get_parent().add_child(n)
		if event.is_action_pressed("delete"):
			for o in $Obstruction.get_overlapping_bodies():
				if not o is input:
					o.queue_free()
		if event.is_action_pressed("rotate_left"):
			rotation_degrees-=90
		if event.is_action_pressed("rotate_right"):
			rotation_degrees+=90
		rotation=fmod(rotation,TAU)
func connecc_selecc():
	for s in get_tree().get_nodes_in_group("CSelectors"):
		s.connect("picked",self,"change_selection")
func change_selection(scene,icon,info):
	selection=scene
	$Placeicon.texture=icon
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
