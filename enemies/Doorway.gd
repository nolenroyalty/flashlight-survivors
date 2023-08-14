extends Node2D

var DefaultEnemy = preload("res://enemies/DefaultEnemy.tscn")

var enemies_to_spawn = 0
var enemies_spawned = 0
var rng : RandomNumberGenerator

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
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

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	enemies_to_spawn = rng.randi_range(3, 10)
	var _ignore = $Timer.connect("timeout", self, "spawn_enemy")
	var t = get_tree().create_tween()
	self.scale = U.v(0.1, 0.9)
	t.tween_property(self, "scale", U.v(1.2, 1.05), 0.3)
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(self, "scale", U.v(1.0, 1.0), 0.2)