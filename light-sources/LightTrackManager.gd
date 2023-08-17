extends Node2D

var IndividualLight = preload("res://light-sources/IndividualLightTrack.tscn")
onready var timer = $Timer
var rng : RandomNumberGenerator

func fire():
	var num = 0
	var moving = false
	var x = rng.randf()
	var y = 1.0 - x
	var vec = Vector2(x, y)

	match State.track_lighting_level:
		1:
			num = 3
		2:
			num = 4
		3:
			num = 5
		4:
			num = 5
			moving = true
	
	# holy magic numbers
	var max_x = 25 + 500 - (vec.x * 2 * 50 * num)
	var max_y = 500 - (vec.y * 2 * 50 * num)
	if moving:
		max_x -= 50 * vec.x
		max_y -= 50 * vec.y
		max_x = max(max_x, 0)
		max_y = max(max_y, 0)

	var x_start = rng.randi_range(50 / 2, max_x)
	var y_start = rng.randi_range(Constants.MIN_Y_ON_SCREEN, max_y)
	var start = U.v(x_start, y_start)

	for i in range(num):
		var il = IndividualLight.instance()
		il.init(start, i, vec, moving)
		add_child(il)

func enable():
	fire()
	timer.start()

func _ready():
	var _ignore = State.connect("tracklights_enabled", self, "enable")
	timer.connect("timeout", self, "fire")
	rng = RandomNumberGenerator.new()
	rng.randomize()
