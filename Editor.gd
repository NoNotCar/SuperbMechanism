extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var placing = preload("res://parts/WaterBar.tscn")
var p1 = null
var epos = null
var place_mode = "wrod"
var snapping = false
export var player = true
export var reload = false
const PREVIEW = Color(0,0,0,0.5)
const SNAP_DIST = pow(5,2)
const WHEEL = preload("res://parts/Wheel.gd")
const ROD = preload("res://parts/Bar.gd")
const BALLOON = preload("res://parts/air/Balloon.gd")
# Called when the node enters the scene tree for the first time.
func _ready():
	Lib.reset()
	Lib.clevel=$Level
	for ps in $CanvasLayer/Parts.get_children():
		if player and (not ps.player or not ps.worlds&int(pow(2,Lib.cworld-1))):
			ps.queue_free()
		else:
			ps.connect("pressed",self,"change_placing",[ps.to_place,ps.place_type])
	if player:
		Lib.load_lvl(false)
		$CanvasLayer/SaveButton.text="Exit"
		$CanvasLayer/Parts.margin_top=-64
	if reload:
		Lib.csave = "res://title/6.sav"
		Lib.load_lvl(false)

func change_placing(new:PackedScene,mode:String):
	placing = new
	place_mode=mode
func snapped_pos():
	var mpos = get_global_mouse_position()
	if $CanvasLayer/SnapButton.pressed:
		mpos = mpos.snapped(Vector2.ONE*8)
	for n in get_tree().get_nodes_in_group("Nodes"):
		if mpos.distance_squared_to(n.position)<SNAP_DIST:
			return n.position
	return mpos
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index==BUTTON_LEFT:
			mpress(event.pressed)

func mpress(pressed:bool):
	var mpos = snapped_pos()
	if pressed:
		p1=mpos
	elif p1!=null:
		if valid(p1,mpos):
			var new = placing.instance()
			new.pos1=p1
			new.pos2=mpos
			new.setup(false)
			$Level.add_child(new)
		elif Lib.sfx:
			$Error.play()
		p1=null
func valid(pos1:Vector2,pos2:Vector2):
	if not player:
		return true
	var within_build = in_build_zone(pos1) and in_build_zone(pos2)
	match place_mode:
		"rod":
			return within_build and rod_cast(pos1,pos2)
		"wrod":
			return within_build and rod_cast(pos1,pos2,1)
		"prop":
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			var rect = RectangleShape2D.new()
			rect.extents=Vector2(8,5)
			query.set_shape(rect)
			query.transform = Transform2D(Vector2.UP.angle_to(pos2-pos1),pos1)
			query.exclude = []
			query.collision_layer=5
			if space.intersect_shape(query):
				return false
			return in_build_zone(pos1)
		"wheel":
			var space = get_world_2d().direct_space_state
			var ignore = []
			var n = Lib.grab_node(pos2)
			if n:
				ignore = n.attached
				for i in ignore:
					if i.get_parent() is WHEEL:
						return false
			var query = Physics2DShapeQueryParameters.new()
			var circle = CircleShape2D.new()
			circle.radius = 9
			query.set_shape(circle)
			query.transform = Transform2D(0,pos2)
			query.exclude = ignore
			query.collision_layer=5
			if space.intersect_shape(query):
				return false
			return in_build_zone(pos2)
		"circle":
			var space = get_world_2d().direct_space_state
			var ignore = []
			var n = Lib.grab_node(pos2)
			if n:
				ignore = n.attached
				for i in ignore:
					if i.get_parent() is BALLOON:
						return false
			var query = Physics2DShapeQueryParameters.new()
			var circle = CircleShape2D.new()
			circle.radius = pos2.distance_to(pos1)
			query.set_shape(circle)
			query.transform = Transform2D(0,pos1)
			query.exclude = ignore
			query.collision_layer=5
			if space.intersect_shape(query):
				return false
			for ang in range(0,10):
				if not in_build_zone(pos1+Vector2.UP.rotated(ang*TAU/10)*circle.radius):
					return false
			return true
	return true
func rod_cast(pos1:Vector2,pos2:Vector2,layer=5):
	if pos1.distance_to(pos2)<5:
		return false
	var space = get_world_2d().direct_space_state
	var ignore = []
	for p in [pos1,pos2]:
		var n = Lib.grab_node(p)
		if n:
			for b in n.attached:
				ignore.append(b)
				var r = b.get_parent()
				if r is ROD and ((r.pos1==pos1 and r.pos2==pos2) or (r.pos2==pos1 and r.pos1==pos2)):
					return false
	var cast = space.intersect_ray(pos1,pos2,ignore,layer)
	if cast:
		return false
	return true
func in_build_zone(pos:Vector2):
	if not player:
		return true
	var space = get_world_2d().direct_space_state
	if space.intersect_point(pos,1,[],1,false,true):
		return true
	return false
func _draw():
	if p1!=null:
		var p2 = snapped_pos()
		match place_mode:
			"rect":
				draw_rect(Lib.to_rect(p1,p2),PREVIEW)
			"circle":
				draw_circle(p1,p1.distance_to(p2),PREVIEW)
			"rod","wrod","prop":
				draw_line(p1,p2,PREVIEW,2,true)
			"wheel":
				draw_circle(p2,9,PREVIEW)
			"ramp":
				draw_colored_polygon(Lib.to_ramp(p1,p2),PREVIEW)

func _process(delta):
	update()
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		var space = get_world_2d().direct_space_state
		var mpos = get_global_mouse_position()
		var cast
		if epos==null:
			cast =space.intersect_point(mpos,1,[],15,true,not player)
			if cast:
				cast= cast[0]
		else:
			cast = space.intersect_ray(epos,mpos,[],15,true,not player)
		if cast:
			var p = cast.collider.get_parent()
			if p is GameObject:
				if not player or p.player:
					Lib.detach(cast.collider)
					p.queue_free()
		epos=mpos
	else:
		epos=null
	if place_mode in ["rod","wrod"] and Input.is_key_pressed(KEY_SHIFT) and Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mpos = get_global_mouse_position()
		if p1!=null and mpos.distance_to(p1)>10:
			mpress(false)
			mpress(true)

func _on_TestButton_pressed():
	Lib.csave="user://temp.sav"
	Lib.save()
	get_tree().change_scene("res://Game.tscn")


func _on_SaveButton_pressed():
	if player:
		get_tree().change_scene("res://gui/LevelSelect.tscn")
	else:
		Lib.csave="res://levels/test.sav"
		Lib.save()
		get_tree().quit()


