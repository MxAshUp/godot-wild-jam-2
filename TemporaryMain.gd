extends Node2D

func _ready():
	get_node( "Play" ).connect( "pressed", self, "play" )


func play():
	#Place your gameplay scene here.
	SceneBrowser.change_scene( "Test" )
	pass