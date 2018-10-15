extends "Jumpable.gd"

const Patrol = preload("Patrol.gd")
var patrol : Node2D
var chasing : Node2D
var chase_alert_level : float = 0
const STOP_ON_ALERT_LEVEL : float = 0.1
const INVESTIGATE_ON_ALERT_LEVEL : float = 1.0
const CHASE_ON_ALERT_LEVEL : float = 1.8
const MAX_CHASE_ALERT_LEVEL : float = 10.0
const MAX_VISION_DISTANCE : float = 270.0
const ALERT_INCREASE_FACTOR : float = 15.0
var can_leap = true
var patrolling : bool = false
var position_follow : Vector2
var follow_object_speed : Vector2
var velocity : Vector2 = Vector2()
var can_see_follow_position = false
var chaseable_bodies : Array = Array()
const MAX_SPEED = 250
const INVESTIGATE_MAX_SPEED = 60
const PATROL_ACCELERATION = 500
const CHASE_ACCELERATION = 1000
const FOLLOW_THRESHOLD = 32
#const LEAP_THRESHOLD = 200
#const LEAP_DISTANCE = 500
const FRICTION = 1500

signal lost_follow_position
signal found_follow_position

func _ready():
	$AnimationPlayer.play("walking")
	$AnimationPlayer.playback_speed = 0

	$ChaseTimeout.connect("timeout", self, "_on_chase_timout")
	#$LeapTimeout.connect("timeout", self, "_on_leap_timeout")
	$VisionArea.connect("body_entered", self, "_on_enter_vision_area")
	$VisionArea.connect("body_exited", self, "_on_exit_vision_area")

func _process(delta):
	if ProjectSettings.get_setting("Global/debug_overlay") or Engine.is_editor_hint():
		update()

	if patrol == null:
		patrol = get_parent()
		if patrol is Patrol:
			patrolling = true
		else:
			patrol = null

	var see_something = false
	if chaseable_bodies.size() > 0 and !chasing:
		for maybe_chase in chaseable_bodies:
			if can_see_position(maybe_chase.global_position, [maybe_chase]):
				see_something = true
				var distance_away = (maybe_chase.global_position - global_position).length()
				chase_alert_level += delta * max(0 , 1 - (distance_away / MAX_VISION_DISTANCE)) * ALERT_INCREASE_FACTOR
				if chase_alert_level > MAX_CHASE_ALERT_LEVEL:
					chase_alert_level = MAX_CHASE_ALERT_LEVEL
				
				if chase_alert_level >= CHASE_ON_ALERT_LEVEL:
					chasing = maybe_chase
					break
		
	if !see_something and chase_alert_level > 0:
		chase_alert_level -= delta
		
	if chasing:
		chase_alert_level = MAX_CHASE_ALERT_LEVEL


	#Modulate myself to show control state.
	#I feel red should be all the non controlled guards
	#though.
	if being_controlled:
		$Sprite.modulate = Color(1,0,0)
	else:
		$Sprite.modulate = Color(1,1,1)

	$AnimationPlayer.playback_speed = (velocity.length() / MAX_SPEED) * 3
	if velocity.x > 0:
		$Sprite.flip_h = true
	elif velocity.x < 0:
		$Sprite.flip_h = false


func can_see_position(to_position : Vector2, exclude : Array = []) -> bool :
	var space_state = get_world_2d().direct_space_state
	var result : Dictionary = space_state.intersect_ray(global_position, to_position, [self] + exclude)
	return result.size() == 0


func _on_chase_timout():
	chasing = null


static func is_chasable(body : Node2D):
	var signals = body.get_signal_list()
	for sig_obj in signals:
		if sig_obj.name == "rescued":
			return true
	return false


func _on_enter_vision_area(body : PhysicsBody2D):
	if body != self and is_chasable(body):
		var index = chaseable_bodies.find(body)
		if index == -1:
			chaseable_bodies.append(body)


func _on_exit_vision_area(body : PhysicsBody2D):
	if body != self and is_chasable(body):
		var index = chaseable_bodies.find(body)
		if index != -1:
			# if chasing == body, maybe act confused
			# Maybe act confused
			chaseable_bodies.remove(index)


#func _on_leap_timeout():
#	can_leap = true


#func leap_to(to_position : Vector2):
#	if !can_leap:
#		return
#	print("leaping")
#	var follow_vector = to_position - self.global_position
#	velocity = move_and_slide(follow_vector.normalized() * LEAP_DISTANCE)
#	can_leap = false
#	$LeapTimeout.start()


func _draw():
	if ProjectSettings.get_setting("Global/debug_overlay") or Engine.is_editor_hint():
		if position_follow:
			(self as Node2D).draw_line(Vector2(0,0), position_follow - global_position, Color(1,1,1))


func process_movement(delta):	
	
	if chasing:
		if can_see_position(chasing.global_position, [chasing]):
			follow_object_speed = chasing.global_position - position_follow
			follow_object_speed = follow_object_speed.normalized() * follow_object_speed.length() / delta
			position_follow = chasing.global_position
			$ChaseTimeout.stop()
			
		elif $ChaseTimeout.time_left == 0:
			$ChaseTimeout.start()
		else:
			var distance_to_point = (position_follow - self.global_position).length()
			if distance_to_point < FOLLOW_THRESHOLD and chase_alert_level > 5.0:
				position_follow = position_follow + follow_object_speed * delta

	elif patrol:
		if chase_alert_level < STOP_ON_ALERT_LEVEL or (chase_alert_level > INVESTIGATE_ON_ALERT_LEVEL and chase_alert_level < CHASE_ON_ALERT_LEVEL):
			position_follow = (patrol as Patrol).get_position_follow()

	
	if position_follow:

		var follow_vector = position_follow - self.global_position

		if can_see_position(position_follow, [chasing]) and follow_vector.length() > FOLLOW_THRESHOLD:
			
			#Do some events
			if can_see_follow_position == false:
				can_see_follow_position = true
				emit_signal("found_follow_position")
				if patrol:
					patrol.emit_signal("in_range", self)

			# adjust velocity
			if chasing:
				velocity += follow_vector.normalized() * CHASE_ACCELERATION * delta
			elif patrol:
				velocity += follow_vector.normalized() * PATROL_ACCELERATION * delta

#			if chasing and follow_vector.length() < LEAP_THRESHOLD:
#				leap_to(position_follow)

		else:
			# Slow down
			var speed = velocity.length()
			speed -= FRICTION * delta
			speed = max(0, speed)
			velocity = velocity.normalized() * speed

			# complain
			if follow_vector.length() > FOLLOW_THRESHOLD:
				if can_see_follow_position == true:
					can_see_follow_position = false
					emit_signal("lost_follow_position")

					if patrol:
						patrol.emit_signal("out_of_range", self)

		
		if chase_alert_level > INVESTIGATE_ON_ALERT_LEVEL and chase_alert_level < CHASE_ON_ALERT_LEVEL:
			if velocity.length() > INVESTIGATE_MAX_SPEED:
				velocity = velocity.normalized() * INVESTIGATE_MAX_SPEED
		else:
			if velocity.length() > MAX_SPEED:
				velocity = velocity.normalized() * MAX_SPEED
							
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