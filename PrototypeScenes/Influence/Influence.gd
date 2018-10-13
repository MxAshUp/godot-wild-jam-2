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
	if function == null :
		print( name + "'s function null. Is the child named Function?" )
	function.perform_function() 
 #end


func body_entered( body ):
	#Connect the body's lnfluence signal.
	body.connect( "influence", self, "become_influenced" )
 #end


func body_exited( body ):
	body.disconnect( "influence", self, "become_influenced" )



func _ready():
	#If a two way col is present, 
	#use that instead of default col.
	if has_node( "TwoWayCol" ) :
		get_node("Col").queue_free()
	
	#Assign the Function node to function lol.
	function = get_node( "Function" )
	
	self.connect( "body_entered", self, "body_entered" )
	self.connect( "body_exited", self, "body_exited" )
	
	get_node( "BecomeInfluenced" ).connect( "pressed", self, "become_influenced")
 #end


