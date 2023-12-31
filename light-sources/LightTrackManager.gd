extends Node2D

var IndividualLight = preload("res://light-sources/IndividualLightTrack.tscn")
onready var timer = $Timer
var rng : RandomNumberGenerator

func fire():
	$Audio.playing = true
	var num = 0
	var x = rng.randf()
	var y = 1.0 - x
	var radius = 55
	var vec = Vector2(x, y)
	var move_mult = 1

	match State.track_lighting_level:
		1:
			num = 3
			radius = 55
		2:
			num = 3
			radius = 65
		3:
			num = 4
			radius = 65
		4:
			num = 4
			radius = 65
			move_mult = 3
		5:
			num = 5
			radius = 65
			move_mult = 2

	var xdelta = vec.x * radius * 2 * (num - 1)
	var ydelta = vec.y * radius * 2 * (num - 1)

	var maxx = max(5, 500 - xdelta)
	var maxy = max(Constants.MIN_Y_ON_SCREEN + 5, 500 - ydelta)
	
	var x_start = rng.randi_range(5, maxx)
	var y_start = rng.randi_range(Constants.MIN_Y_ON_SCREEN, maxy)
	var start = U.v(x_start, y_start)

	for i in range(num):
		var il = IndividualLight.instance()
		il.init(start, move_mult, i, vec, radius)
		add_child(il)

func enable():
	fire()
	timer.start()

func disable():
	timer.stop()

func _ready():
	var _ignore = State.connect("tracklights_enabled", self, "enable")
	timer.connect("timeout", self, "fire")
	rng = RandomNumberGenerator.new()
	rng.randomize()
