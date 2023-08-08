extends Node2D

const MAX_FIXED_LIGHTS = 5

class Circle:
	var pos = Vector2()
	var tween = null
	var radius = 0.0

	func init(pos_, radius_):
		pos = pos_
		radius = radius_
	
	func to_vec3(viewport_size):
		var pos_ = pos / viewport_size
		return Vector3(pos_.x, pos_.y, radius)

var player = Circle.new()
var flashlight_direction := Vector2(0, 0)
var fixed_lights = []
var fixed_light_idx = 0

func _ready():
	for _i in range(MAX_FIXED_LIGHTS):
		var c = Circle.new()
		c.init(Vector2(0, 0), 0.0)
		fixed_lights.append(c)

func add_fixed_light(pos, radius):
	var tween = get_tree().create_tween()
	var c = fixed_lights[fixed_light_idx]
	c.init(pos, 0.0)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(c, "radius", radius, 1.0)
	fixed_light_idx = (fixed_light_idx + 1) % MAX_FIXED_LIGHTS
