extends LightSource

onready var shape := $CollisionShape2D

const BASE_RADIUS = 35
var radius = BASE_RADIUS setget set_radius, get_radius

func get_radius():
	return radius

func set_radius(v):
	radius = v
	shape.shape.radius = v
	Lights.player.radius = v

func handle_lamp_increased(level):
	# Circles scale quadratically with radius but idk this is fun
	radius = BASE_RADIUS + level * 5

func _ready():
	seconds_per_tick = 0.5
	damage_per_tick = 0.0
	set_radius(radius)
	var _ignore = State.connect("lamp_increased", self, "handle_lamp_increased")