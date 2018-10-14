extends "Jumpable.gd"

const Patrol = preload("Patrol.gd")
var patrol : Node2D
var chasing : Node2D
var can_leap = true
var patrolling : bool = false
var position_follow : Vector2
var velocity : Vector2 = Vector2()
var can_see_follow_position = false
const MAX_SPEED = 250
const ACCELERATION = 500
const FOLLOW_THRESHOLD = 32
#const LEAP_THRESHOLD = 200
#const LEAP_DISTANCE = 500
const FRICTION = 1000

signal lost_follow_position
signal found_follow_position

func _ready():
	patrol = get_parent()
	if patrol is Patrol:
		patrolling = true
	else:
		patrol = null

	$AnimationPlayer.play("walking")
	$AnimationPlayer.playback_speed = 0

	$ChaseTimeout.connect("timeout", self, "_on_chase_timout")
	#$LeapTimeout.connect("timeout", self, "_on_leap_timeout")

	chasing = get_node('../../Hostage')


func _process(delta):
	if ProjectSettings.get_setting("Global/debug_overlay") or Engine.is_editor_hint():
		update()

	if patrol == null:
		patrol = get_parent()
		if patrol is Patrol:
			patrolling = true
		else:
			patrol = null

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


func _on_leap_timeout():
	can_leap = true


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
			position_follow = chasing.global_position
			$ChaseTimeout.stop()
		elif $ChaseTimeout.time_left == 0:
			$ChaseTimeout.start()

	elif patrol:
		position_follow = (patrol as Patrol).get_position_follow()

	if position_follow:

		var follow_vector = position_follow - self.global_position

		if can_see_position(position_follow, [chasing]) and follow_vector.length() > FOLLOW_THRESHOLD:
			if can_see_follow_position == false:
				can_see_follow_position = true
				emit_signal("found_follow_position")
				if patrol:
					patrol.emit_signal("in_range", self)

			velocity += follow_vector.normalized() * ACCELERATION * delta

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