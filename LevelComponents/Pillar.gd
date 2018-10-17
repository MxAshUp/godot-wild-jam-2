extends Sprite


#Pillar.
#Tries to look like it slides down when
#closed.


onready var is_open : bool = get_parent().door_open


func _ready():
	get_parent().connect( "interact", self, "change_open_state" )
	
	#Close if open.
	if is_open :
		for child in get_children() :
			child.show()
			
			$Wall.set_collision_layer_bit( 0, false )



func change_open_state():
	#Slide up or down based on open state.
	is_open = get_parent().door_open
	if is_open :
		$Wall.set_collision_layer_bit( 0, false )
		is_open = false
		
		#Raise piller.
		for child in get_children() :
			child.show()
	
	
	else:
		$Wall.set_collision_layer_bit( 0, true )
		is_open = true
		
		#Lower pillar
		for child in get_children() :
			child.hide()
		
		




