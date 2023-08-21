extends CanvasLayer

signal tutorial_complete()

var first_mouse_pos : Vector2
var mouse_gone = false
var wasd_gone = false

func maybe_emit():
	if mouse_gone and wasd_gone:
		emit_signal("tutorial_complete") 


var count = 0
func maybe_free():
	count += 1
	if count == 2:
		call_deferred("queue_free")


func _process(_delta):
	var new_mouse_pos = get_viewport().get_mouse_position()
	if new_mouse_pos.distance_to(first_mouse_pos) > 30 and not mouse_gone:
		mouse_gone = true
		maybe_emit()
		var t = get_tree().create_tween()
		t.tween_property($Mouse, "modulate:a", 0.0, 0.5)
		t.tween_callback(self, "maybe_free")

	if Input.is_action_just_pressed("player_left") \
		or Input.is_action_just_pressed("player_right") \
		or Input.is_action_just_pressed("player_up") \
		or Input.is_action_just_pressed("player_down"):
		if not wasd_gone:	
			wasd_gone = true
			maybe_emit()
			var t = get_tree().create_tween()
			t.tween_property($Wasd, "modulate:a", 0.0, 0.5)
			t.tween_callback(self, "maybe_free")
	

func _ready():
	first_mouse_pos = get_viewport().get_mouse_position()