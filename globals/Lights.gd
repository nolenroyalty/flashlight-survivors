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
var fading_lights = []
var fixed_light_idx = 0

func _ready():
	for _i in range(MAX_FIXED_LIGHTS):
		fixed_lights.append(Circle.new())
		fading_lights.append(Circle.new())

func add_fixed_light(pos, radius):
	
	var c = fixed_lights[fixed_light_idx]
	var dupe = fading_lights[fixed_light_idx]
	dupe.init(c.pos, c.radius)
	
	var tween = get_tree().create_tween()
	c.init(pos, 0.0)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(c, "radius", radius, 1.0)

	var fade_tween = get_tree().create_tween()
	fade_tween.set_trans(Tween.TRANS_CUBIC)
	fade_tween.set_ease(Tween.EASE_IN)
	fade_tween.tween_property(dupe, "radius", 0.0, 1.0)

	fixed_light_idx = (fixed_light_idx + 1) % MAX_FIXED_LIGHTS

func all_lights():
	return fixed_lights + fading_lights
