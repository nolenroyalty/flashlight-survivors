extends KinematicBody2D
class_name BaseEnemy

var Explosion = preload("res://light-sources/Explosion.tscn")
var is_dead = false
var health = 1
var touching_player = false
var power = 1
var xp_gain = 1
var seconds_per_attack = 0.1

func maybe_explode():
	if State.should_explode():
		var explosion = Explosion.instance()
		explosion.position = position
		get_parent().call_deferred("add_child", explosion)
		return true
	return false

func handle_death():
	call_deferred("queue_free")

func die():
	if is_dead:
		return
	is_dead = true
	U.xpbar.add_xp(xp_gain)
	if maybe_explode():
		call_deferred("queue_free")
	else:
		handle_death()

func play_damage_animation():
	var t = get_tree().create_tween()
	# t.tween_property(self, "modulate", Color("#645f678e"), 0.35)
	# t.tween_property(self, "modulate", Color("#dd30408c"), 0.35)
	t.tween_property(self, "modulate", Color("#99d8b47a"), 0.15)
	t.tween_property(self, "modulate", Color("#ffffff"), 0.15)
	t.set_trans(Tween.TRANS_QUAD)

func damage(amount):
	if is_dead:
		return
	
	health -= amount
	if health <= 0:
		die()
	else:
		play_damage_animation()

		
func deal_damage_if_touching():
	if not is_dead and touching_player:
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

func play_spawn_animation():
	scale = U.v(0.1, 0.6)
	var t = get_tree().create_tween()
	t.tween_property(self, "scale", U.v(1.1, 1.05), 0.3)
	t.tween_property(self, "scale", U.v(1.0, 1.0), 0.3)
	t.set_ease(Tween.EASE_OUT_IN)
	t.set_trans(Tween.TRANS_QUAD)

func _ready():
	var _ignore = $Hitbox.connect("area_entered", self, "on_touched_player")
	_ignore = $Hitbox.connect("area_exited", self, "on_stopped_touching_player")
	scale = U.v(0.1, 0.1)
	play_spawn_animation()
