extends Node2D

#This is a script that lets you draw a line
#from point a to point b. 
#I need to make it where I can update the
#point properly.

var color : Color = Color( 1,1,1,1 )
var end_point : Vector2
var start_point : Vector2
var width : float = 5.0

#These member variables will update as the object
#that contains the values updates.
export var end_object = "n"
export var start_object = "n"
export var end_value = "n"
export var start_value = "n"



func _draw():
	draw_line( start_point, end_point, color, width )


func _process(delta):
	update_vars()
	update()


#func _ready():
#	#This disables processing. Draw needs to be told to start()
#	set_process( false ) 


func start():
	set_process( true )


func update_vars():
	if( start_object != "n" &&
	start_object != "n" ):
		var get_start = get_node( start_object ).get( start_value )
		if get_start == null:
			print( name + "'s method update vars had an error in get_start" )
		
		start_point = get_start
	
	
	if( end_object != "n" &&
	end_value != "n" ):
		var get_end = get_node( end_object ).get( end_value )
		if get_end == null:
			print( name + "'s method update vars had an error in get_end" )
		
		end_point = get_end


