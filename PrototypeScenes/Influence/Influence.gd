tool
extends Area2D

#A scene which all influence capable objects
#should use. It handles all influence logic.

#USE: You need to make another scene a child
#of this scene and name it Function for this
#scene to use it.

var function



func become_influenced():
	#Should I pass a reference to the body that did
	#the influencing?
	function.perform_function() 
 #end


func body_entered( body ):
	#Connect the body's lnfluence signal.
	body.connect( "influence", self, "become_influenced" )
 #end


func body_exited( body ):
	body.disconnect( "influence", self )



func _process(delta):
	#To avoid ready errors, keep looking for the Function
	#node. When it is present, function gets assigned.
	if self.has_node( "Function" ) :
		function = get_node( "Function" )
		set_process( false )
 #end



func _ready():
	#If a two way col is present, 
	#use that instead of default col.
	if has_node( "TwoWayCol" ) :
		get_node("Col").queue_free()
	
	self.connect( "body_entered", self, "body_entered" )
	self.connect( "body_exited", self, "body_exited" )
 #end