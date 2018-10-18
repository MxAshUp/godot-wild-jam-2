extends Node2D


#Script node
export var is_on = false

signal interact


func _ready():
	self.connect( "interact", self, "interact" )
	
	#Display myself as having been pressed.
	if is_on :
		$SwitchOn.show()
		$SwitchOff.hide()


func interact():
	#Change my sprite if I am called to.
	if is_on :
		#Turn off
		$SwitchOn.hide()
		$SwitchOff.show()
		is_on = false
	
	else:
		#Turn on
		$SwitchOn.show()
		$SwitchOff.hide()
		is_on = true