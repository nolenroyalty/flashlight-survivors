extends Node2D
var Enemy = preload("res://enemies/DefaultEnemy.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if Input.is_action_just_pressed("debug_spawn_enemy"):
		var enemy = Enemy.instance()
		enemy.init($Player)
		add_child(enemy)
