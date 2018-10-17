tool
extends "Jumpable.gd"


signal rescued #When the hostage is rescued, this gets emitted.
signal hostage_caught

var velocity : Vector2 = Vector2()
const MAX_SPEED = 200
const ACCELERATION = 1400
const FRICTION = 1500

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
	GameCamera.set_target( self )	


func _on_DieDetections_body_entered(body : PhysicsBody2D):
	emit_signal("hostage_caught", body)
	# TODO - have root node handle this
	LevelHandler.restart()
