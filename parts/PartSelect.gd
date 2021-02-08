extends Button


export var to_place:PackedScene
export (String, "rod","wrod", "wheel", "rect","circle","ramp") var place_type = "rod"
var player:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	player = to_place.instance().player


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
