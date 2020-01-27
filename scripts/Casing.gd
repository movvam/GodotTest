extends RigidBody2D

onready var shot = $AudioStreamPlayer2D
onready var shell = $AudioStreamPlayer2D2

var start_vel = Vector2.ZERO

func init(pos, start_vel):
	position = pos
	self.start_vel = start_vel
	
func _ready():
	var cursor_pos = get_viewport().get_mouse_position()
	
	var velocity = ((cursor_pos - position).normalized() * 200)
	
	# Rotate to the right and add player velocity
	velocity = Vector2(-velocity.y, velocity.x)
	velocity += start_vel
	
	apply_central_impulse(velocity)
	set_angular_velocity(-15)
	
	shot.stream = load("res://audio/gunshot.wav")
	shot.play()
	
	yield(get_tree().create_timer(.3), "timeout")
	
	shell.stream = load("res://audio/shell.wav")
	shell.play()
	
	# After 5 seconds destroy
	yield(get_tree().create_timer(1), "timeout")
	$AnimationPlayer.play("fade_out")
	yield(get_tree().create_timer(1), "timeout")
	queue_free()