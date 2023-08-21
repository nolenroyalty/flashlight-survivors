extends Node2D
var UpgradeDialogue = preload("res://ui/UpgradeDialogue.tscn")
var LoseScreen = preload("res://ui/LoseScreen.tscn")
var UIHelpers = preload("res://ui/UIHelpers.tscn")

onready var player = $Player
onready var healthbar = $Healthbar
onready var xpbar = $XPBar
onready var camera = $ShakeCamera

var rng : RandomNumberGenerator 
var player_start_position : Vector2

func upgrade_finished(ud):
	ud.call_deferred("queue_free")
	get_tree().paused = false

func on_reached_level(level):
	print("reached level %d" % [level])
	var ud = UpgradeDialogue.instance()
	add_child(ud)
	ud.connect("finished", self, "upgrade_finished", [ud])
	get_tree().paused = true

func start():
	$SpawnManager.enable()
	State.set_start_time()

func show_tutorial():
	var tut = UIHelpers.instance()
	add_child(tut)
	tut.connect("tutorial_complete", self, "start")

func restart():
	get_tree().paused = false
	show_tutorial()

func handle_death():
	get_tree().paused = true
	var ls = LoseScreen.instance()
	ls.connect("loaded", self, "reset_everything")
	ls.connect("restart", self, "restart")
	add_child(ls)

func reset_everything():
	player.reset(player_start_position)
	$ShakeCamera.reset()
	State.reset()
	xpbar.reset()
	healthbar.set_health(State.player_health)
	$LightTrackManager.disable()
	$SpawnManager.disable()
	AudioManager.stop_all()

# Called when the node enters the scene tree for the first time.
func _ready():
	var _ignore = State.connect("health_set", healthbar, "set_health")
	_ignore = State.connect("player_died", self, "handle_death")
	xpbar.connect("reached_level", self, "on_reached_level")
	healthbar.set_health(State.player_health)
	_ignore = State.connect("add_trauma", camera, "add_trauma")
	player_start_position = player.position
	U.player = player
	U.xpbar = xpbar
	rng = RandomNumberGenerator.new()
	rng.randomize()

	show_tutorial()
