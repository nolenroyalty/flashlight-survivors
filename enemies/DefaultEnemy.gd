extends KinematicBody2D

onready var anim = $AnimationPlayer
onready var hitbox = $Hitbox

enum S { ALIVE, DEAD }

const SPEED = 75
var health = 5
var power = 1
var player : Node2D = null
var state = S.ALIVE
var touching_player = false
# Maybe we should just get rid of this? It's weird to have it + iframes
var seconds_per_attack = 0.1

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

func deal_damage_if_touching():
	if touching_player:
		player.damage(power)
		var timer = get_tree().create_timer(seconds_per_attack)
		timer.connect("timeout", self, "deal_damage_if_touching")

func on_touched_player(area):
	var player_ = area.get_parent()
	if player != player_:
		print("wtf? player is not player. %s | %s" % [ player, player_])
		return
	touching_player = true
	deal_damage_if_touching()

func on_stopped_touching_player(area):
	var player_ = area.get_parent()
	if player != player_:
		print("wtf? player is not player. %s | %s" % [ player, player_])
		return
	touching_player = false


func _ready():
	var _ignore = $Hitbox.connect("area_entered", self, "on_touched_player")
	_ignore = $Hitbox.connect("area_exited", self, "on_stopped_touching_player")