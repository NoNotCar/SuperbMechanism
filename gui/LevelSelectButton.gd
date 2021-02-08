extends Button


# Declare member variables here. Examples:
export var file = "test"
const COMPLETE_MOD = Color8(153,230,95)
var done:=false

# Called when the node enters the scene tree for the first time.
func _ready():
	if file in Lib.done:
		modulate=COMPLETE_MOD
		done=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
