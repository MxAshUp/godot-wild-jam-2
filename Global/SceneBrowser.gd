extends Node


#This is a SceneBrowser.


#Call change_scene( "SceneName" )  to change scene.

#Add the path to scenes in get_scene
var loader : ResourceInteractiveLoader

func load_scene( scene_name ):
	#Add the path to scenes here.

	if scene_name == "Path Test" :
		return load( "res://PrototypeScenes/Patrol/PathTest.tscn" )
	if scene_name == "Integration Test" :
		return load( "res://PrototypeScenes/GameplayIntegration/Test-1.tscn" )

func change_scene( scene_name ):
	var new = get_scene( scene_name )
	new = load( new )
	get_tree().change_scene_to( new )
 #end


func change_scene_with_load( scene_name, loader_name = "Hi" ):
	#I figured we might want different loader's each time or
	#something. Hence the loader argument.
	var new_scene = get_scene( scene_name )
	loader = ResourceLoader.load_interactive( new_scene )
	set_process( true )
 #end


#ADD HERE
func get_scene( scene_name ):
	#Return a string for the load methods to use.
	#Add the path to the scenes here.
	if scene_name == "Test" :
		return "res://PrototypeScenes/Patrol/PathTest.tscn"
 #end


func _process(delta):
	loader.poll()

	if loader.get_resource() != null :
		get_tree().change_scene_to( loader.get_resource() )
		get_tree().paused = false
		set_process( false )
		return
 #end


func _ready():
	set_process( false )
 #end


