extends Node


onready var camera : Camera2D = $Camera
onready var text = $Camera/Node2D
const text_offset : Vector2 = Vector2( -30, -280 )
var current_target
var previous_target

#For resetting the timer


func _ready():
	set_process( false )
	text.get_node( "Timer" ).connect( "timeout", self, "timer_done" )
	
	
	

func hide_timer():
	text.get_node( "Timer" ).hide()



func show_timer():
	text.get_node( "Timer" ).show()



func make_current():
	camera.make_current()


func revert_target():
	if previous_target != null:
		set_target( previous_target )



func set_target( target, instant_jump : bool = false, offset : Vector2 = Vector2( 0,0 ) ):
	#Follow this target.
	previous_target = current_target
	current_target = target

	camera.make_current()
	
	#Jump instantly to the new target if needed.
	if instant_jump :
		camera.global_position = target.global_position
	
	camera.position += offset
	
	set_process( true )



func set_timer_time( new_time : float ):
	var set_timer = text.get_node( "Timer" )
	set_timer.stop()
	set_timer.wait_time = new_time



func start_timer():
	#Begin counting down
	text.get_node( "Timer" ).start()



func _process( delta ):
	
	var goto : Vector2 = current_target.global_position
	goto -= camera.global_position
	goto = goto.clamped( 20 )
	camera.global_position += goto
	
	#Update timer text
	text.global_position = text_offset + camera.get_camera_screen_center()
	text.get_node( "Text" ).text = str( round( text.get_node( "Timer" ).time_left ) )
	
	

func stop_target():
	set_process( false )
	current_target = null


func timer_done():
	text.get_node( "Timer" ).stop()
	LevelHandler.restart()
	
	