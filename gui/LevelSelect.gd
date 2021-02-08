extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const levels = {"hump":"Bumpy Road","elevate":"Elevate","smolbridge":"Mind The Gap",
"stairs":"Stairs","5balls":"Five Balls","australia":"Australia","bigbridge":"Too Far?"}
const LSB = preload("res://gui/LevelSelectButton.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var incomplete = 0
	for lname in levels:
		if not lname in Lib.done:
			incomplete+=1
			if incomplete>3:
				continue
		var ls = LSB.instance()
		ls.file = lname
		ls.text=levels[lname]
		$CenterContainer/Grid.add_child(ls)
		ls.connect("pressed",self,"start_level",[ls.file])
		if lname=="hump" and not "hump" in Lib.done:
			return

func start_level(fname:String):
	Lib.csave = "res://levels/%s.sav" % fname
	Lib.clname=fname
	get_tree().change_scene("res://Editor.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
