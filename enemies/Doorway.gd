extends Node2D

onready var anim = $AnimationPlayer

var DefaultEnemy = preload("res://enemies/DefaultEnemy.tscn")

var enemies_to_spawn = 0
var enemies_spawned = 0
var rng : RandomNumberGenerator

func stop_and_fade():
	$Timer.stop()
	var t = get_tree().create_tween()
	t.tween_property(self, "scale", U.v(0.1, 0.9), 0.4)
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_callback(self, "queue_free")

func spawn_enemy():
	if enemies_spawned < enemies_to_spawn:
		var t = get_tree().create_tween()
		t.tween_property(self, "scale", U.v(1.2, 1.0), 0.3)
		t.tween_property(self, "scale", U.v(1.0, 1.0), 0.3)
		t.set_trans(Tween.TRANS_QUAD)
		var enemy = DefaultEnemy.instance()
		get_parent().add_child(enemy)
		enemy.position = position
		enemies_spawned += 1
		if enemies_spawned == enemies_to_spawn:
			stop_and_fade()
	else:
		print("BUG: spawn_enemy called when no enemies left to spawn")
		stop_and_fade()

func on_collapse_played(name):
	if name == "collapse":
		call_deferred("queue_free")

var i_have_taken_damage = false
func damage(_amount):
	if i_have_taken_damage:
		return
	i_have_taken_damage = true
	if State.door_should_collapse():
		$Timer.stop()
		anim.play("collapse")
		anim.connect("animation_finished", self, "on_collapse_played")

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	enemies_to_spawn = rng.randi_range(3, 10)
	var _ignore = $Timer.connect("timeout", self, "spawn_enemy")
	anim.play("appear")