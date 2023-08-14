extends Area2D
class_name LightSource

var seconds_per_tick = 10.0
var damage_per_tick = 1.0
var bodies = {}

func start_damage_timer(body):
	var timer = get_tree().create_timer(seconds_per_tick)
	timer.connect("timeout", self, "damage_if_present", [body])

func damage_if_present(body):
	if bodies.has(body):
		if damage_per_tick > 0:
			print("Dealing %d damage to %s" % [damage_per_tick, body])
			body.damage(damage_per_tick)
		start_damage_timer(body)

func entered(area):
	var body = area.get_parent()
	bodies[body] = true 
	start_damage_timer(body)

func exited(area):
	var body = area.get_parent()
	bodies.erase(body)

func _ready():
	# var _ignore = connect("body_entered", self, "on_body_entered")
	# _ignore = connect("body_exited", self, "on_body_exited")
	var _ignore = connect("area_entered", self, "entered")
	_ignore = connect("area_exited", self, "exited")