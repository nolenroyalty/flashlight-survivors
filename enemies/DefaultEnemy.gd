extends KinematicBody2D

onready var anim = $AnimationPlayer

enum S { ALIVE, DEAD }

const SPEED = 75
var health = 5
var player : Node2D = null
var state = S.ALIVE

func init(player_ : Node2D):
	player = player_

func _physics_process(_delta):
	match state:
		S.ALIVE:
			var dir = position.direction_to(player.position)
			var _extra_velocity = move_and_slide(SPEED * dir)

func set_spin_and_transparency(spin, transparency):
	rotation_degrees = spin
	$Sprite.modulate.a = transparency

func die_when_dead(name):
	if name == "die":
		call_deferred("queue_free")

func die():
	state = S.DEAD
	anim.play("die")
	anim.connect("animation_finished", self, "die_when_dead")

func damage(amount):
	if state == S.DEAD:
		return
	# This should maybe make them fade more as they have taken more damage!
	health -= amount
	if health <= 0:
		die()
	else:
		anim.play("damage")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
