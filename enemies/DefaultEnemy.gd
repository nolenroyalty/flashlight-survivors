extends KinematicBody2D

var Explosion = preload("res://light-sources/Explosion.tscn")
onready var anim = $AnimationPlayer
onready var hitbox = $Hitbox

enum S { ALIVE, DEAD }

const SPEED = 75
var health = 5
var power = 1
var state = S.ALIVE
var touching_player = false
var xp_gain = 5
# Maybe we should just get rid of this? It's weird to have it + iframes
var seconds_per_attack = 0.1

func _physics_process(_delta):
	match state:
		S.ALIVE:
			var dir = position.direction_to(U.player.position)
			var _extra_velocity = move_and_slide(SPEED * dir)

func set_spin_and_transparency(spin, transparency):
	rotation_degrees = spin
	$Sprite.modulate.a = transparency

func die_when_dead(name):
	if name == "die":
		call_deferred("queue_free")

func maybe_explode():
	var exploded = State.should_explode()
	if exploded:
		var explosion = Explosion.instance()
		# explosion.init(position)
		explosion.position = position
		get_parent().call_deferred("add_child", explosion)
		return true
	return false

func die():
	state = S.DEAD
	U.xpbar.add_xp(xp_gain)
	if maybe_explode():
		call_deferred("queue_free")
	else:
		anim.play("die")
		$AnimatedSprite.play("die")
		anim.connect("animation_finished", self, "die_when_dead")
	
func alive():
	return state == S.ALIVE

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
	if alive() and touching_player:
		U.player.damage(power)
		var timer = get_tree().create_timer(seconds_per_attack, false)
		timer.connect("timeout", self, "deal_damage_if_touching")

func on_touched_player(area):
	var player_ = area.get_parent()
	if U.player != player_:
		print("wtf? player is not player. %s | %s" % [ U.player, player_])
		return
	touching_player = true
	deal_damage_if_touching()

func on_stopped_touching_player(area):
	var player_ = area.get_parent()
	if U.player != player_:
		print("wtf? player is not player. %s | %s" % [ U.player, player_])
		return
	touching_player = false


func _ready():
	var _ignore = $Hitbox.connect("area_entered", self, "on_touched_player")
	_ignore = $Hitbox.connect("area_exited", self, "on_stopped_touching_player")
	self.scale = U.v(0.1, 0.1)
	anim.play("spawn")
