extends KinematicBody2D

onready var area = $Area2D

onready var raycast = $RayCast2D
export var SPEED = 250

var shot_dir = Vector2.ZERO
var body_hit = false

func init(start_pos, shot_dir):
	position = start_pos
	look_at(start_pos + shot_dir)
	self.shot_dir = shot_dir
	

	
func _ready():
	#area.connect("body_entered", self, "handle_body_enter")
	pass
	
func _physics_process(delta):
	position += shot_dir * SPEED * delta
	if raycast.is_colliding():
		
		# create some debris
		var debris = preload("res://objects/Debris.tscn").instance()
		debris.init(position)
		get_parent().add_child(debris)
		
		#var push_back = shot_dir * 900
		
		# Center + the place where we collided
		
		var coll = raycast.get_collider()
		#var hit_loc = Vector2.ZERO + (position - coll.position)
		#coll.move_and_slide(push_back)
		if coll.has_method("kill"):
			coll.kill()
			queue_free()