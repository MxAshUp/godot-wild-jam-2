extends Node

#Right now, this just quits the game
#if ESC is pressed.

func _input(event):
	if event.is_action( "pause" ):
		get_tree().quit()