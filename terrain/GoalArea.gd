extends "res://terrain/Zone.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal complete

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	var targets = get_tree().get_nodes_in_group("Targets")
	var inside = $Area2D.get_overlapping_bodies()
	for t in targets:
		if not t in inside:
			return
	Lib.complete_level()
	emit_signal("complete")
