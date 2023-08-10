extends KinematicBody2D

onready var anim = $AnimationPlayer

const SPEED = 75
var player : Node2D = null

func init(player_ : Node2D):
	player = player_

func _physics_process(_delta):
	var dir = position.direction_to(player.position)
	var _extra_velocity = move_and_slide(SPEED * dir)

func damage(_amount):
	anim.play("damage")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
