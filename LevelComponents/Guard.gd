tool
extends "Jumpable.gd"
const Patrol = preload("Patrol.gd")
var patrol : Node
var patrolling : bool = false
var position_follow : Position2D
var go_to_position : Vector2
var velocity : Vector2 = Vector2()
const max_speed = 250
const acceleration = 500

func _ready():
	patrol = get_parent()
	if patrol is Patrol:
		patrolling = true
	else:
		patrol = null
		
	$AnimationPlayer.play("walking")
	$AnimationPlayer.playback_speed = 0
	

func _process(delta):
	if patrol == null:
		patrol = get_parent()
		if patrol is Patrol:
			patrolling = true
		else:
			patrol = null
	
	if position_follow:
		var patrol_position = position_follow.global_position
		go_to_position = Vector2(patrol_position.x, patrol_position.y)
	elif patrol:
		position_follow = (patrol as Patrol).get_position_follow()
	
	
	#Modulate myself to show control state.
	#I feel red should be all the non controlled guards
	#though. 
	if being_controlled:
		$Sprite.modulate = Color(1,0,0)
	else:
		$Sprite.modulate = Color(1,1,1)

	$AnimationPlayer.playback_speed = (velocity.length() / max_speed) * 3
	if velocity.x > 0:
		$Sprite.flip_h = true
	elif velocity.x < 0:
		$Sprite.flip_h = false

func can_see_position(to_position : Vector2) -> bool :
	var space_state = get_world_2d().direct_space_state
	var result : Dictionary = space_state.intersect_ray(position, to_position, [self])
	return result.size() == 0


func process_movement(delta):
	if go_to_position:
		
		var follow_vector = go_to_position - self.position
		
		if can_see_position(go_to_position) and follow_vector.length() > 32:
			velocity += follow_vector.normalized() * acceleration * delta
			
		else:
			var speed = velocity.length()
			speed -= acceleration * delta * 2
			speed = max(0, speed)
			velocity = velocity.normalized() * speed
			
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
			
		var new_velocity = move_and_slide(velocity)
		if velocity.length() > 0:
#			if new_velocity.length()/velocity.length() < 0.5:
				#OOF! Hit something that slowed us down
#				pass
			pass
		velocity = new_velocity	


func _physics_process(delta):
	if !Engine.is_editor_hint():
		process_movement(delta)