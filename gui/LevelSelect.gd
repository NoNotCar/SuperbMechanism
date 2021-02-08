extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const levels = {1:{"hump":"Bumpy Road","elevate":"Elevate","smolbridge":"Mind The Gap",
"stairs":"Stairs","5balls":"Five Balls","elevate2":"Elevate Again","holeinone":"Hole In One","australia":"Australia",
"bigbridge":"Too Far?"},2:{"uphill":"Uphill Struggle"}}
const LSB = preload("res://gui/LevelSelectButton.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var incomplete = 0
	if Lib.cworld==1:
		$Previous.queue_free()
	for lname in levels[Lib.cworld]:
		if not lname in Lib.done:
			incomplete+=1
			if incomplete>3:
				continue
		var ls = LSB.instance()
		ls.file = lname
		ls.text=levels[Lib.cworld][lname]
		$CenterContainer/Grid.add_child(ls)
		ls.connect("pressed",self,"start_level",[ls.file])
		if lname=="hump" and not "hump" in Lib.done:
			$Next.queue_free()
			return
	if incomplete>=3 or Lib.cworld==2:
		$Next.queue_free()

func start_level(fname:String):
	Lib.csave = "res://levels/%s.sav" % fname
	Lib.clname=fname
	get_tree().change_scene("res://Editor.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Next_pressed():
	Lib.switch_world(Lib.cworld+1)
	get_tree().reload_current_scene()


func _on_Previous_pressed():
	Lib.switch_world(Lib.cworld-1)
	get_tree().reload_current_scene()
