extends LightSource

onready var shape := $CollisionShape2D

const BASE_RADIUS = 38
var radius = BASE_RADIUS setget set_radius, get_radius

func get_radius():
	return radius

func set_radius(v):
	radius = v
	shape.shape.radius = v
	Lights.player.radius = v

func handle_lamp_increased(level):
	match level:
		1:
			seconds_per_tick = 2.0
			damage_per_tick = 1.0
		2, 3, 4:
			set_radius(BASE_RADIUS + (level - 1) * 15)

func _ready():
	seconds_per_tick = 0.5
	damage_per_tick = 0.0
	set_radius(radius)
	var _ignore = State.connect("lamp_increased", self, "handle_lamp_increased")