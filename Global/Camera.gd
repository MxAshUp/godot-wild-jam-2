extends Node


onready var camera : Camera2D = Camera2D.new()


var previous_target

#Eventually make the target



func revert_target():
	if previous_target != null:
		set_target( previous_target )



func set_target( target, offset : Vector2 = Vector2( 0,0 ) ):
	#Follow this target.
	if camera != Camera2D :
		camera = Camera2D.new()
	
	else:
		previous_target = camera.get_parent()
		camera.get_parent().remove_child( camera )
	target.call_deferred( "add_child", camera )
	camera.make_current()
	camera.global_position += offset
