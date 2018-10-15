extends Sprite


const SWING = deg2rad( 90 )

#This reverts the swing.
#var swing_back : float 

onready var is_open : bool = get_parent().door_open


func _ready():
	get_parent().connect( "interact", self, "swing" )
	
	if is_open :
		self.rotation = SWING


func swing():
	if is_open :
		#Close the door
		self.rotation = 0 #Make this tween back
		is_open = false
	else:
		#Open the door
		self.rotation = SWING
		is_open = true

	
	
	