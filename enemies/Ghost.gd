extends BaseEnemy

const SPEED = 75

func die_when_dead(name):
	if name == "die":
		call_deferred("queue_free")

func handle_death():
	$AnimatedSprite.play("die")
	$AnimationPlayer.play("die")
	var _ignore = $AnimationPlayer.connect("animation_finished", self, "die_when_dead")

func _physics_process(_delta):
	if is_dead: return
	
	var dir = position.direction_to(U.player.position)
	var _v = move_and_slide(SPEED * dir)

func _ready():
	health = 3
	xp_gain = 3

