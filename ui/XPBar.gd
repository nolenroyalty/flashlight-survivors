extends Node2D

# Not very principled to store XP here vs in state, but also it doesn't matter so shrug

onready var bar_tween = $BarTween

signal reached_level(level)
var xp = 0

func xp_required():
	# Come back and fix this
	return 30 * State.player_level

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
		bar_tween.stop_all()
		$Foreground.rect_scale.x = 1.0
		State.player_level += 1
		xp = xp - req
		emit_signal("reached_level", State.player_level)
	set_foreground_scale()

func _ready():
	$Foreground.rect_scale.x = 0
	set_foreground_scale()
