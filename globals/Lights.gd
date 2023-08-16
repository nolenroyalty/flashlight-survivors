extends Node2D

signal alarm_flash_set(value)

const MAX_FIXED_LIGHTS = 5
var FixedLight = preload("res://player/FixedLight.tscn")

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

func vec3_of_fixed_light(fl, viewport_size):
	var pos = fl.position / viewport_size
	var radius = fl.radius / viewport_size.x
	return Vector3(pos.x, pos.y, radius)

# I mean this doesn't really belong here but whatever
func add_fixed_light(pos, radius):
	fading_lights[fixed_light_idx] = fixed_lights[fixed_light_idx]
	var dupe = fading_lights[fixed_light_idx]

	var fl = FixedLight.instance()
	# Ahhhh this is b ad
	get_tree().get_current_scene().add_child(fl)
	fl.position = pos
	fl.radius = 0.0
	fixed_lights[fixed_light_idx] = fl

	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(fl, "radius", radius, 1.0)

	if dupe != null and is_instance_valid(dupe):
		dupe.fade(1.0)

	fixed_light_idx = (fixed_light_idx + 1) % MAX_FIXED_LIGHTS


func vec3_or_zero(node, viewport_size):
	if node == null or not is_instance_valid(node):
		return Vector3(0, 0, 0)
	else:
		return vec3_of_fixed_light(node, viewport_size)

func get_all_lights(viewport_size):
	var l = []
	for fl in fixed_lights:
		l.append(vec3_or_zero(fl, viewport_size))
	for fl in fading_lights:
		l.append(vec3_or_zero(fl, viewport_size))
	return l
