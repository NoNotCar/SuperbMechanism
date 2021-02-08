extends Node2D
class_name GameObject

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pos1:Vector2
var pos2:Vector2
export var player = false

# Called when the node enters the scene tree for the first time.
func setup(game:bool):
	pass

func save_data():
	return [pos1,pos2]
func load_data(data):
	pos1=data[0]
	pos2=data[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
