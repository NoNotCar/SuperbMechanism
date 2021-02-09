extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Lib.reset()
	Lib.clevel = $Level
	Lib.load_lvl(true)
	for g in get_tree().get_nodes_in_group("Goal"):
		g.connect("complete",self,"level_complete")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func level_complete():
	if Lib.sfx:
		$Complete.play()
	$GUI/Theme/StopButton.queue_free()
	$GUI/Theme/Complete.show()
func _on_StopButton_pressed():
	get_tree().change_scene("res://Editor.tscn")


func _on_Continue_pressed():
	get_tree().change_scene("res://gui/LevelSelect.tscn")
