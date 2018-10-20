extends Node


onready var camera : Camera2D = Camera2D.new()

var current_target
var previous_target

#Eventually make the target


func _ready():
	self.call_deferred( "add_child", camera )
	set_process( false )
	
	
func make_current():
	camera.make_current()


func revert_target():
	if previous_target != null:
		set_target( previous_target )



func set_target( target, offset : Vector2 = Vector2( 0,0 ) ):
	#Follow this target.
	
	#Old
	previous_target = current_target
	current_target = target
#	camera.get_parent().remove_child( camera )
#	camera.position = Vector2( 0,0 )

#	target.call_deferred( "add_child", camera )
	camera.make_current()
	camera.position += offset
	
	set_process( true )


	pass
	
func _process( delta ):
	var goto : Vector2 = current_target.global_position
	goto -= camera.global_position
	goto = goto.clamped( 20 )
	camera.global_position += goto