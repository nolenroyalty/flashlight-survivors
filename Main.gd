extends Node2D
var UpgradeDialogue = preload("res://ui/UpgradeDialogue.tscn")

onready var player = $Player
onready var healthbar = $Healthbar
onready var xpbar = $XPBar
onready var camera = $ShakeCamera
var rng : RandomNumberGenerator 

func upgrade_finished(ud):
	ud.call_deferred("queue_free")
	get_tree().paused = false

func on_reached_level(level):
	print("reached level %d" % [level])
	var ud = UpgradeDialogue.instance()
	add_child(ud)
	ud.connect("finished", self, "upgrade_finished", [ud])
	get_tree().paused = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var _ignore = State.connect("health_set", healthbar, "set_health")
	xpbar.connect("reached_level", self, "on_reached_level")
	healthbar.set_health(State.player_health)
	_ignore = State.connect("add_trauma", camera, "add_trauma")
	U.player = player
	U.xpbar = xpbar
	rng = RandomNumberGenerator.new()
	rng.randomize()
