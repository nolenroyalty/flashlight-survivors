extends LightSource

const FLASH_TIME = 0.6
const WAIT_TIME = 6.0
var lights_on = false
onready var timer = $Timer
onready var collider = $CollisionPolygon2D

func calculate_wait_time():
	return WAIT_TIME - (State.fire_alarm_level - 1) * 0.85

func handle_enable():
	flash()

func stop_flashing():
	Lights.set_alarm_flashing(false)
	collider.disabled = true
	bodies = {}

func flash():
	collider.disabled = false
	var t = get_tree().create_tween()
	Lights.set_alarm_flashing(true)
	t.tween_callback(self, "stop_flashing").set_delay(FLASH_TIME)
	timer.start(calculate_wait_time())

func _ready():
	var _ignore = State.connect("alarm_enabled", self, "handle_enable")
	timer.connect("timeout", self, "flash")
	damage_per_tick = 1
	seconds_per_tick = null
	damage_on_first_tick = true

