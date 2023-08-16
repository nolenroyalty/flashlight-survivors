extends Node2D

onready var bar_tween = $BarTween

signal reached_level(level)

var level = 1
var xp = 0

func xp_required():
	# Come back and fix this
	return 10 * level

func set_foreground_scale():
	var req = xp_required()
	var scale = float(xp) / req
	bar_tween.stop_all()
	bar_tween.interpolate_property($Foreground, "rect_scale:x", null, scale, 0.7, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	bar_tween.start()
	
func add_xp(amount):
	xp += amount
	var req = xp_required()
	if xp >= req:
		level += 1
		xp = xp - req
		emit_signal("reached_level", level)
	set_foreground_scale()

func _ready():
	$Foreground.rect_scale.x = 0
	set_foreground_scale()
