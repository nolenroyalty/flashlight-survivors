extends Node2D

signal alarm_flash_set(value)

const MAX_FIXED_LIGHTS = 5

# Circle is only used by player and it's confusing, oops

class Circle:
	var pos = Vector2()
	var tween = null
	var radius = 0.0

	func init(pos_, radius_):
		pos = pos_
		radius = radius_
	
	func to_vec3(viewport_size):
		var pos_ = pos / viewport_size
		var radius_ = radius / viewport_size.x
		return Vector3(pos_.x, pos_.y, radius_)

var player = Circle.new()
var flashlight_direction := Vector2(0, 0)
var fixed_lights = []
var fading_lights = []
var fixed_light_idx = 0
var light_cone_angle = 0.0
var alarm_flashing = false setget set_alarm_flashing

func _ready():
	for _i in range(MAX_FIXED_LIGHTS):
		fixed_lights.append(null)
		fading_lights.append(null)

func set_alarm_flashing(value):
	alarm_flashing = value
	emit_signal("alarm_flash_set", value)

func set_light(fl, idx):
	fixed_lights[idx] = fl

func vec3_or_zero(node, viewport_size):
	if node == null or not is_instance_valid(node):
		return Vector3(0, 0, 0)
	else:
		var pos = node.position / viewport_size
		var radius = node.current_radius / viewport_size.x
		return Vector3(pos.x, pos.y, radius)

func get_all_lights(viewport_size):
	var l = []
	for fl in fixed_lights:
		l.append(vec3_or_zero(fl, viewport_size))
	for fl in fading_lights:
		l.append(vec3_or_zero(fl, viewport_size))
	return l
