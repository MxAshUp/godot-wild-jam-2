extends Node

var current_level : int = 0

var level_array : Array = [ "Level 1" , "Level 2" ]



func next_level():
	#Move onto the next level in the array of levels.
	#Right now, just keep playing the test scene again and
	#again.
	
	current_level += 1
	print(current_level)
	if current_level > level_array.size() :
		current_level = level_array.size()
		SceneBrowser.change_scene( "Main Menu" )
		
	else:
		SceneBrowser.change_scene( level_array[ current_level ] )



func restart():
	SceneBrowser.change_scene( level_array[ current_level ] )


func start_game():
	#Begin the game from the beginning.
	current_level = 0
	Music.at_stealth()
	SceneBrowser.change_scene( level_array[ current_level ] )






