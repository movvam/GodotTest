extends KinematicBody2D

onready var gun = $Gun
onready var sights = $Cursor
onready var audio = $Audio
onready var empty = $Empty

const ACCEL = 1000 # ACCELERATION (* delta)
const SPEED = 100 # MAX SPEED
const LASER_COLOR = Color(150, 0, 0)
const SHOT_DELAY = 0.15
const MAGAZINE_SIZE = 15

var velocity = Vector2.ZERO
var hit_pos = Vector2.ZERO
var cursor_pos = Vector2.ZERO
var fire_delay = 0
var current_bullet = 0

func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	axis.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	
	return axis.normalized()
	
func apply_movement(acceleration):
	velocity += acceleration
	velocity = velocity.clamped(SPEED)
	
func apply_friction(deceleration):
	if velocity.length() > deceleration:
		velocity -= velocity.normalized() * deceleration
	else:
		velocity = Vector2.ZERO

func handle_actions():
	if Input.is_action_pressed("shoot"):
		if fire_delay > SHOT_DELAY:
			if current_bullet < MAGAZINE_SIZE:
				Globals.shake_screen(2)
				
				# Position of gun
				var gun_pos = (position + gun.position)
				
				# Create casing
				var casing = preload("res://objects/Casing.tscn").instance()
				casing.init(gun_pos, velocity)
				get_parent().add_child(casing)
				
				# Create bullet
				var bullet = preload("res://objects/Bullet.tscn").instance()
				var shot_dir = (gun_pos - position).normalized()
				bullet.init(gun_pos, shot_dir)
				get_parent().add_child(bullet)
				
				# Move player back
				velocity -= (cursor_pos - position).normalized() * 20
				
				current_bullet += 1
				fire_delay = 0
			else:
				audio.stream = load("res://audio/click.wav")
				audio.play()
	if Input.is_action_just_pressed("reload"):
		fire_delay = -1
		yield(get_tree().create_timer(.1), "timeout")
		audio.stream = load("res://audio/reload.wav")
		audio.play()
		yield(get_tree().create_timer(.4), "timeout")
		current_bullet = 0
		
func _draw():
	pass
	#var gun_pos = (cursor_pos - position).normalized() * 14
	#draw_line(gun_pos, (hit_pos - position), LASER_COLOR)
	#draw_circle(hit_pos - position, 1.5, LASER_COLOR)
	#draw_circle(Vector2.ZERO, 1.5, LASER_COLOR)
	#draw_circle((cursor_pos-position), 1.5, Color(0, 150, 0))

func _ready():
	yield(get_tree(), "idle_frame")
	# Hide cursor
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().call_group("zombies", "set_player", self)

func _physics_process(delta):
	# Calls draw function
	#update()
	
	# Update the fire_delay
	fire_delay += delta
	
	# Get cursor
	cursor_pos = get_viewport().get_mouse_position()
	sights.position = (cursor_pos - position)
	
	# Rotate gun to cursor
	var gun_origin = Vector2.ZERO
	var angle = position.angle_to_point(cursor_pos)
	gun.position = gun_origin + (Vector2(-14, 0) - gun_origin).rotated(angle)
	gun.look_at(cursor_pos)

	# Movement
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(ACCEL * delta)
	else:
		apply_movement(axis * ACCEL * delta)
	
	# Magazine empty
	if current_bullet == MAGAZINE_SIZE:
		empty.set_percent_visible(1)
	else:
		empty.set_percent_visible(0)
	
	# Actions
	handle_actions()
	
	velocity = move_and_slide(velocity)
	
func kill():
	get_tree().reload_current_scene()