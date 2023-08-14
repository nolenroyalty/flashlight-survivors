extends Node2D
var Enemy = preload("res://enemies/DefaultEnemy.tscn")
var Door = preload("res://enemies/Doorway.tscn")

onready var player = $Player
onready var healthbar = $Healthbar
onready var xpbar = $XPBar
var rng : RandomNumberGenerator 

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("health_set", healthbar, "set_health")
	healthbar.set_health(player.health)
	U.player = player
	U.xpbar = xpbar
	rng = RandomNumberGenerator.new()
	rng.randomize()


func _process(_delta):
	if Input.is_action_just_pressed("debug_spawn_enemy"):
		var enemy = Enemy.instance()
		add_child(enemy)
	if Input.is_action_just_pressed("debug_spawn_door"):
		var door = Door.instance()
		var x = rng.randi_range(50, 400)
		var y = rng.randi_range(50, 300)
		door.position = Vector2(x, y)
		add_child(door)

