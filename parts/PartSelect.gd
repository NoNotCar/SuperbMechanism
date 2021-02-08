extends Button


export var to_place:PackedScene
export (String, "rod","wrod", "wheel", "rect","circle","ramp","prop") var place_type = "rod"
var player:bool
var worlds:int
# Called when the node enters the scene tree for the first time.
func _ready():
	var inst = to_place.instance()
	player = inst.player
	worlds = inst.worlds
	inst.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
