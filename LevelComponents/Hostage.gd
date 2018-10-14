extends KinematicBody2D


export var run_speed = 200
var being_controlled = true

func _process( delta ):
	if being_controlled :
	#Get WASD movement
		var move : Vector2 = Vector2( 0,0 )
		move.x += int( Input.is_action_pressed( "ui_right" ) )
		move.x += -int( Input.is_action_pressed( "ui_left" ) )
		move.y += int( Input.is_action_pressed( "ui_down" ) )
		move.y += -int( Input.is_action_pressed( "ui_up" ) )
		
		move_and_slide( move * run_speed )