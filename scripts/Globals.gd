extends Node

# Grab that camera
var camera = null
var screen_shaking = false

# Shakes the screen
func shake_screen(duration):
	screen_shaking = true
	
	# wait for anim to be done
	yield(get_tree().create_timer(duration), "timeout")
	screen_shaking = false
	if camera:
		camera.set_offset(Vector2(0, 0))

func _ready():
	for node in get_tree().get_root().get_children():
		match node.get_name():
			"Camera2D":
				camera = node

func _physics_process(delta):
	# do screen shake
	if screen_shaking:
		if camera:
			camera.set_offset(Vector2(rand_range(-0.5, 0.5) * 1, rand_range(-0.5, 0.5) * 1))