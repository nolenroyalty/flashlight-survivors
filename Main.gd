extends Node2D
var Enemy = preload("res://enemies/DefaultEnemy.tscn")

onready var player = $Player
onready var healthbar = $Healthbar

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("health_set", healthbar, "set_health")
	healthbar.set_health(player.health)
	pass # Replace with function body.


func _process(_delta):
	if Input.is_action_just_pressed("debug_spawn_enemy"):
		var enemy = Enemy.instance()
		enemy.init($Player)
		add_child(enemy)
