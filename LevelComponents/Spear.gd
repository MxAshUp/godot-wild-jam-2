extends Area2D


#Orcs must die!
#A hostage can pick this spear up
#and use it later to kill an orc.


var is_collectable : bool = true #When off, spear can kill

var hostage 


const HOSTAGE_LAYER = 2
const GUARD_LAYER = 3


#Travel speed.
var velocity = Vector2( 200, 0 )


func _ready():
	self.connect( "body_entered", self, "body_entered" )
	
	#Don't start processing until I have been thrown
	set_process( false )
	set_process_input( false )


func _input(event):
	if event.is_action("spear") :
		#Throw spear in direction hostage is traveling.
		self.show()
		set_process( true )
		set_process_input( false )
		self.global_position = hostage.global_position
		$Col.rotate( hostage.velocity.angle() )
		$Sprite.rotate( hostage.velocity.angle() )
		velocity = velocity.rotated( hostage.velocity.angle() )
		self.set_collision_mask_bit( GUARD_LAYER, true )



func _process(delta):
	#Move the spear to the destination.
	#If it hits a wall, stop moving.
	self.global_position += velocity * delta



func body_entered( body ):
	#Hostage collected spear.
	if is_collectable :
		self.hide()
		hostage = body
		self.set_collision_mask_bit( HOSTAGE_LAYER, false )
		is_collectable = false
		set_process_input( true )
	
	
	else:
		#Orcs must die.
		body.emit_signal( "die" )
		self.queue_free()
		
		
		
		
	
		
		