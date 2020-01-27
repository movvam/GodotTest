extends RigidBody2D

func init(pos):
	position = pos

func _ready():
	# Create some random initial velocity
	var r_vel = Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)).normalized() * 200
	apply_central_impulse(r_vel)
	
	# wait 5 seconds and then pop out
	yield(get_tree().create_timer(5), "timeout")
	$AnimationPlayer.play("fade_out")
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
