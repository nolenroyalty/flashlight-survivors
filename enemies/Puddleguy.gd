extends BaseEnemy

signal despawned()

var PuddleShard = preload("res://enemies/PuddleShard.tscn")
onready var anim = $AnimationPlayer

func handle_death():
	var t = get_tree().create_tween()
	t.tween_property(self, "scale", U.v(0.1, 0.2), 0.35)
	t.set_trans(Tween.TRANS_QUAD)
	t.set_trans(Tween.EASE_OUT)
	t.tween_callback(self, "emit_signal", ["despawned"])
	t.tween_callback(self, "call_deferred", ["queue_free"])

func animation_finished(name):
	if name == "errupt" and not is_dead:
		for dir in ["nw", "ne", "sw", "se"]:
			var shard = PuddleShard.instance()
			shard.init(dir)
			shard.position = position
			get_parent().add_child(shard)
	emit_signal("despawned")
	call_deferred("queue_free")

func play_spawn_animation():
	pass

func _ready():
	health = 2
	xp_gain = 5
	anim.play("errupt")
	anim.connect("animation_finished", self, "animation_finished")
