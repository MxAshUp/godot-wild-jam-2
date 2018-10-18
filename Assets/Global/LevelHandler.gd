extends Node

var current_level : int = 0

var level_array : Array = [ "A Full Map" ]



func next_level():
	#Move onto the next level in the array of levels.
	#Right now, just keep playing the test scene again and
	#again.
	
	current_level += 1
	if current_level >= level_array.size() :
		current_level -= 1 #Remove this later.
		pass #You beat the game.
	
	SceneBrowser.change_scene( level_array[ 0 ] )



func restart():
	SceneBrowser.change_scene( level_array[ current_level ] )


func start_game():
	#Begin the game from the beginning.
	current_level = 0
	SceneBrowser.change_scene( level_array[ current_level ] )






