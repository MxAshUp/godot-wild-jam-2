extends Node


onready var camera : Camera2D = Camera2D.new()





func set_target( target ):
	#Follow this target.
	if camera != Camera2D :
		camera = Camera2D.new()
	
	else:
		camera.get_parent().remove_child( camera )
	target.call_deferred( "add_child", camera )
	camera.make_current()
