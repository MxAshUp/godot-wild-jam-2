tool
extends "Jumpable.gd"

export var run_speed = 200

signal rescued #When the hostage is rescued, this gets emitted.
signal hostage_caught


func _process( delta ):
	
	$SpiritParticles.emitting = being_controlled
	
	if being_controlled :
	#Get WASD movement
		var move : Vector2 = Vector2( 0,0 )
		move.x += int( Input.is_action_pressed( "ui_right" ) )
		move.x += -int( Input.is_action_pressed( "ui_left" ) )
		move.y += int( Input.is_action_pressed( "ui_down" ) )
		move.y += -int( Input.is_action_pressed( "ui_up" ) )
		move = move.clamped( 1 )
		
		move_and_slide( move * run_speed )


func _ready():
	if being_controlled :
		Music.at_chase()
	
	self.connect( "rescued", self, "rescued" )
	self.connect( "jumped", self, "start_chase" )


func rescued():
	#Begin playing animations and victory sounds etc.
	pass


func start_chase( instance ):
	Music.at_chase()
	GameCamera.set_target( self )	


func _on_DieDetections_body_entered(body : PhysicsBody2D):
	emit_signal("hostage_caught", body)
