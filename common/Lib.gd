extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const N = preload("res://parts/Node.tscn")
const backcols = [Color8(85,223,255),Color8(85,223,255)]
const terrcols = [Color8(51,152,75),Color8(0,152,220)]
var terrain_colour = Color8(51,152,75)
var darker_terrain = terrain_colour.darkened(0.3)
var clevel:Node2D
var nodes = {}
var csave = "res://levels/test.sav"
var clname:String
var done = []
var cworld = 1

const around = [Vector2.UP,Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT]
# Called when the node enters the scene tree for the first time.
func _ready():
	done = load_var("user://done.sav",[])
func reset():
	nodes.clear()
func attach(pos:Vector2,r:PhysicsBody2D=null):
	var n = grab_node(pos)
	if not n:
		n = N.instance()
		n.position=pos
		nodes[pos]=n
		clevel.add_child(n)
	if r:
		n.add_body(r)
func grab_node(pos):
	for p in nodes:
		if p.distance_squared_to(pos)<0.1:
			return nodes[p]
	return null
func detach(r:PhysicsBody2D):
	for p in nodes.duplicate():
		var n = nodes[p]
		if r in n.attached:
			n.attached.erase(r)
			if not n.attached:
				n.queue_free()
				nodes.erase(p)
func save():
	var f = File.new()
	f.open(csave,File.WRITE)
	for t in clevel.get_children():
		if t is GameObject:
			f.store_var(t.filename)
			f.store_var(t.save_data())
	f.close()
func save_var(fname:String,v):
	var f = File.new()
	f.open(fname,File.WRITE)
	f.store_var(v)
	f.close()
func load_var(fname:String,default):
	var f = File.new()
	if f.file_exists(fname):
		f.open(fname,File.READ)
		default=f.get_var()
		f.close()
	return default

func load_lvl(game:bool):
	var f = File.new()
	f.open(csave,File.READ)
	while f.get_position()<f.get_len():
		var new = load(f.get_var()).instance()
		new.load_data(f.get_var())
		new.setup(game)
		clevel.add_child(new)
	f.close()

func complete_level():
	if not clname in done:
		done.append(clname)
		save_var("user://done.sav",done)
func switch_world(to:int):
	cworld=to
	terrain_colour=terrcols[to-1]
	darker_terrain=terrain_colour.darkened(0.3)
	VisualServer.set_default_clear_color(backcols[to-1])
	
static func to_rect(p1:Vector2,p2:Vector2)->Rect2:
	return Rect2(min(p1.x,p2.x),min(p1.y,p2.y),abs(p1.x-p2.x),abs(p1.y-p2.y))
static func to_ramp(pos1:Vector2,pos2:Vector2):
	var base = max(pos1.y,pos2.y)
	return [pos1,pos2,Vector2(pos2.x if pos1.y==base else pos1.x,base)]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
