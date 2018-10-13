extends Node2D

func _ready():
	get_node( "Play" ).connect( "pressed", self, "play" )


func play():
	#Place your gameplay scene here.
#	get_tree().change_scene( "scene/path" )
	pass