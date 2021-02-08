extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var last_level=0
var lvl:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	reload()
func reload():
	if lvl:
		lvl.queue_free()
	Lib.reset()
	lvl=Node2D.new()
	add_child(lvl)
	Lib.clevel=lvl
	var l=last_level
	while l==last_level:
		l = randi()%6+1
	last_level=l
	Lib.csave = "res://title/%s.sav" % l
	Lib.load_lvl(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	get_tree().change_scene("res://gui/LevelSelect.tscn")


func _on_Timer_timeout():
	$Tween.interpolate_property($CanvasLayer/Fog,"modulate",Color(1,1,1,0),Color(1,1,1),1.0,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	reload()
	$Tween.interpolate_property($CanvasLayer/Fog,"modulate",Color(1,1,1),Color(1,1,1,0),1.0,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.start()
