extends "Jumpable.gd"
const Patrol = preload("Patrol.gd")
var patrol : Node
var patrolling : bool = false
var position_follow : Position2D
var go_to_position : Vector2 = self.position
var velocity : Vector2 = Vector2()
export var max_speed = 100

func _ready():
	patrol = get_parent()
	if patrol is Patrol:
		patrolling = true
	
func _process(delta):
	if position_follow:
		var patrol_position = position_follow.global_position
		go_to_position = Vector2(patrol_position.x, patrol_position.y)
	elif patrol:
		position_follow = (patrol as Patrol).get_position_follow()

func _physics_process(delta):
	if go_to_position:
		var follow_vector = go_to_position - self.position
		velocity = follow_vector.normalized() * max_speed 
		velocity = move_and_slide(velocity)
		