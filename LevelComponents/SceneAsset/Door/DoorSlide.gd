extends Sprite

#I animated it to look like it was sliding.

const SLIDE_END = 64 #Stops the slide.


export var frame_wait = 2
export var slide_add : int = 2

var slide_amount : int = 0



onready var is_open : bool = get_parent().door_open



func _ready():
	#I need to disappear if I am open.
	if is_open :
		self.position.x += SLIDE_END
		self.region_rect.size.x -= SLIDE_END
		self.slide_amount += SLIDE_END
	
	else:
		slide_add = -slide_add
	
	get_parent().connect( "interact", self, "start_slide" )
	set_process( false )


func _process(delta):
	if frame_wait == 0 :
		frame_wait = 2
		
		self.region_rect.size.x -= slide_add
		self.position.x += slide_add
		self.slide_amount += slide_add
		
		#Flip if we have hit the end of slide.
		if( slide_amount >= 64 ||
				slide_amount <= 0 ):
					set_process( false )
		
	#Frame wait still needs to happen
	frame_wait -= 1
	


func start_slide():
	#Flip slide direction
	self.slide_add = -slide_add
	set_process( true )


