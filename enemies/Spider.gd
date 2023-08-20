extends BaseEnemy

onready var sprite = $AnimatedSprite
onready var roll_safeguard_timer = $RollSafeguard

enum S { UNROLL, LOOK, START_ROLL, ROLLING, DYING }
var state = S.UNROLL
var roll_destination : Vector2
var initial_move_direction
const SPEED = 200
const ROTATIONS_A_SECOND = 1

func clamp_x(x):
	return min(max(x, 25), 475)

func clamp_y(y):
	return min(max(y, Constants.MIN_Y_ON_SCREEN + 25), 475)

func pick_roll_destiation():
	var x = U.player.position.x + rand_range(-50, 50)
	var y = U.player.position.y + rand_range(-50, 50)
	roll_destination = U.v(clamp_x(x), clamp_y(y))

func finished_rolling():
	roll_safeguard_timer.stop()
	var t = get_tree().create_tween()
	t.tween_property(self, "rotation_degrees", 0.0, 0.1)
	state = S.UNROLL
	sprite.play("stop roll")

func _physics_process(delta):
	if state == S.UNROLL and initial_move_direction != null:
		var _v = move_and_slide(initial_move_direction * SPEED / 2.0)

	if state == S.ROLLING:
		if position.distance_to(roll_destination) < 20:
			finished_rolling()
		else:
			var dir = position.direction_to(roll_destination)
			var _v = move_and_slide(dir * SPEED)
			var rot = ROTATIONS_A_SECOND * 360 * delta
			rotate(rad2deg(rot))

func roll_safeguard_fired():
	if state == S.ROLLING:
		print("%s roll safeguard fired: stopping roll" % self)
		finished_rolling()

func handle_death():
	match state:
		S.ROLLING:
			sprite.play("die roll")
		S.UNROLL, S.START_ROLL, S.LOOK:
			sprite.play("die legs")
		S.DYING:
			print("BUG: handle_death called when already dying")
	state = S.DYING

func animation_finished():
	match state:
		S.UNROLL:
			state = S.LOOK
			sprite.play("look")
			initial_move_direction = null
		S.LOOK:
			state = S.START_ROLL
			sprite.play("start roll")
			roll_safeguard_timer.start(5.0)
		S.START_ROLL:
			state = S.ROLLING
			pick_roll_destiation()
			sprite.play("roll")
		S.ROLLING:
			pass
		S.DYING:
			call_deferred("queue_free")
			
func unroll_finished():
	sprite.play("look")

func play_spawn_animation():
	pass

func maybe_neg():
	if rand_range(0, 1) == 0:
		return -1
	else:
		return 1

func spawn():
	scale = U.v(0.1, 0.6)
	var t = get_tree().create_tween()
	t.tween_property(self, "scale", U.v(1.1, 1.05), 2.5 / 8)
	t.tween_property(self, "scale", U.v(1.0, 1.0), 2.5 / 8)
	t.set_ease(Tween.EASE_OUT_IN)
	t.set_trans(Tween.TRANS_QUAD)
	sprite.play("stop roll")
	t.tween_callback(self, "unroll_finished")

	var dx = randf() * maybe_neg()
	var dy = randf() * maybe_neg()
	initial_move_direction = Vector2(dx, dy).normalized()

func _ready():
	randomize()
	health = 10
	power = 2
	xp_gain = 6
	sprite.connect("animation_finished", self, "animation_finished")
	roll_safeguard_timer.connect("timeout", self, "roll_safeguard_fired")
	spawn()
