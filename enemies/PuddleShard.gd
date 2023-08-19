extends BaseEnemy

onready var hitbox = $Hitbox
onready var hurtbox = $Hurtbox
onready var sprite = $Sprite

const MAX_SPEED = 350
const ACCEL = 10
var velocity = Vector2()

var dir : String
var vec : Vector2

func handle_death():
	var t = get_tree().create_tween()
	var t2 = get_tree().create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.3)
	t2.tween_property(self, "scale", U.v(0.0, 0.0), 0.3)
	t.tween_callback(self, "call_deferred", ["queue_free"])

func _process(delta):
	if is_dead:
		return
	
	velocity += delta * ACCEL * vec
	var collision = move_and_collide(velocity)
	if collision:
		is_dead = true
		handle_death()

func actually_damage():
	.actually_damage()
	is_dead = true
	handle_death()

func init(dir_):
	match dir_:
		"nw", "ne", "sw", "se":
			dir = dir_
		_:
			print("BUG INVALID DIR: %s" % dir_)

func play_spawn_animation():
	pass

func _ready():
	health = 3
	power = 2
	xp_gain = 0
	match dir:
		"nw":
			$Sprite.frame = 15
			$Hitbox/nw.disabled = false
			$Hurtbox/nw.disabled = false
			$nw.disabled = false
			vec = Vector2(-1, -1).normalized()
		"ne":
			$Sprite.frame = 16
			$Hitbox/ne.disabled = false
			$Hurtbox/ne.disabled = false
			$ne.disabled = false
			vec = Vector2(1, -1).normalized()
		"se":
			$Sprite.frame = 17
			$Hitbox/se.disabled = false
			$Hurtbox/se.disabled = false
			$se.disabled = false
			vec = Vector2(1, 1).normalized()
		"sw":
			$Sprite.frame = 18
			$Hitbox/sw.disabled = false
			$Hurtbox/sw.disabled = false
			$sw.disabled = false
			vec = Vector2(-1, 1).normalized()
