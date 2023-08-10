extends LightSource

onready var shape := $CollisionShape2D

var radius = 34.5 setget set_radius, get_radius

func get_radius():
	return radius

func set_radius(v):
	radius = v
	shape.shape.radius = v
	Lights.player.radius = v

func _ready():
	seconds_per_tick = 0.5
	damage_per_tick = 0.0
	set_radius(radius)
