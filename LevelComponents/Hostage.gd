tool
extends "Jumpable.gd"


export var run_speed = 200


signal rescued #When the hostage is rescued, this gets emitted.



func end_chase( instance ):
	Music.revert()


func _process( delta ):
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
	self.connect( "jumped_from", self, "end_chase" )


func rescued():
	#Begin playing animations and victory sounds etc.
	pass


func start_chase( instance ):
	Music.at_chase()


