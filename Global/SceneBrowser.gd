extends Node


#This is a SceneBrowser.

#Call make_new_scene( "SceneName" )


func load_scene( scene_name ):
	#Add the path to scenes here.

	if scene_name == "Path Test" :
		return load( "res://PrototypeScenes/Patrol/PathTest.tscn" )
	if scene_name == "Integration Test" :
		return load( "res://PrototypeScenes/GameplayIntegration/Test-1.tscn" )

func change_scene( scene_name ):
	var new_scene = load_scene( scene_name )
	get_tree().change_scene_to( new_scene )