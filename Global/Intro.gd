extends Node2D


func _process(delta):
	self.global_position = get_parent().get_node( "Camera" ).get_camera_screen_center()


func _ready():
	set_process( false )
	self.hide()
	$AnimationPlayer.connect( "animation_finished", self, "anim_end" )


func start_intro():
	set_process( true )
	self.show()
	$AnimationPlayer.play( "logoFadeout" )


func anim_end():
	set_process( false )