extends Node2D

export (int)var SPEED = 100

var myidx = 2;
var light_radius = 0.15;

func _physics_process(delta):
	var dx = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	var dy = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	var dir = Vector2(dx, dy).normalized()
	position += dir * SPEED * delta
	Lights.player_circle.pos = position

func _ready():
	Lights.player_circle.pos = position
	Lights.player_circle.radius = light_radius
