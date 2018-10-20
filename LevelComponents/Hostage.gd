tool
extends "Jumpable.gd"


signal rescued #When the hostage is rescued, this gets emitted.
signal hostage_caught

var velocity : Vector2 = Vector2()
var last_move_dir = 0.0
const MAX_SPEED = 200
const ACCELERATION = 1900
const FRICTION = 2600

func _process( delta ):
	
	$SpiritParticles.emitting = being_controlled
	
	var move : Vector2 = Vector2( 0,0 )
	
	if being_controlled :
	#Get WASD movement
		move.x += int( Input.is_action_pressed( "ui_right" ) )
		move.x += -int( Input.is_action_pressed( "ui_left" ) )
		move.y += int( Input.is_action_pressed( "ui_down" ) )
		move.y += -int( Input.is_action_pressed( "ui_up" ) )
		move = move.clamped( 1 )

	if move.length() > 0:
		velocity += move * ACCELERATION * delta
	else:
		var speed = velocity.length()
		speed -= FRICTION * delta
		speed = max(0, speed)
		velocity = velocity.normalized() * speed

	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED
	
	velocity = move_and_slide(velocity)

	process_animation(delta)

func process_animation(delta):
	var animation_to_play = $AnimationPlayer.current_animation
	$AnimationPlayer.playback_speed = 1

	var left_right_move = false
	
	if animation_to_play == "walk_lr":
		animation_to_play = "idle_lr"
	elif animation_to_play == "walk_up":
		animation_to_play = "idle_up"
	elif animation_to_play == "walk_down":
		animation_to_play = "idle_down"
	

	if abs(velocity.x) > abs(velocity.y):
		if velocity.x < 0:
			last_move_dir = -1.0
	
		if velocity.x > 0:
			last_move_dir = 1.0
		
		if abs(velocity.x) > 1.0:
			animation_to_play = "walk_lr"
	else:
	
		if velocity.y > 1.0:
			animation_to_play = "walk_down"
		
		if velocity.y < -1.0:
			animation_to_play = "walk_up"
		
	$AnimationPlayer.playback_speed = (velocity.length() / MAX_SPEED) * 1.5
		
	if animation_to_play != $AnimationPlayer.current_animation:
		$AnimationPlayer.play(animation_to_play)
	
	# maybe flip sprite, if supported (ending with _lr)
	if animation_to_play.ends_with('_lr'):
		if last_move_dir < 0:
			$CharacterSprite.flip_h = true
		elif last_move_dir > 0:
			$CharacterSprite.flip_h = false

func _ready():
	if being_controlled :
		Music.at_chase()
	
	self.connect( "rescued", self, "rescued" )
	self.connect( "jumped", self, "start_chase" )


func rescued():
	# Begin playing animations and victory sounds etc.
	pass


func start_chase( instance ):
	Music.at_chase()
#	GameCamera.set_target( self )	


func _on_DieDetections_body_entered(body : PhysicsBody2D):
	emit_signal("hostage_caught", body)
	# TODO - have root node handle this
	LevelHandler.restart()
