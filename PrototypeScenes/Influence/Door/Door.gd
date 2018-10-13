extends StaticBody2D


export var door_open : bool = false


#The door.

func _ready():
	get_node( "Button" ).connect( "pressed", self, "temp" )


func temp():
	perform_function()



func perform_function():
	if door_open :
		#Close door
		self.set_collision_layer_bit( 0, true )
		$Col.show()
		door_open = false
	else:
		#open door
		self.set_collision_layer_bit( 0, false )
		$Col.hide()
		door_open = true
 #end