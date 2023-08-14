extends LightSource

onready var shape := $CollisionShape2D

var radius = 30.0 setget set_radius, get_radius

func set_radius(v):
	radius = v
	shape.shape.radius = v

func get_radius():
	return radius

func fade(time):
	var fade_tween = get_tree().create_tween()
	fade_tween.set_trans(Tween.TRANS_CUBIC)
	fade_tween.set_ease(Tween.EASE_IN)
	fade_tween.tween_property(self, "radius", 0.0, time)
	fade_tween.tween_callback(self, "queue_free")

func _ready():
	seconds_per_tick = 0.5
	damage_per_tick = 1.0
