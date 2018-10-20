tool
extends Node2D


#Script node
export var is_on = false setget update_is_on

signal interact


func _ready():
	self.connect( "interact", self, "interact" )
	
	update_state()

func update_state():
	if !$SwitchOn or !$SwitchOff:
		return
		
	if is_on :
		$SwitchOn.show()
		$SwitchOff.hide()
	else:
		$SwitchOn.hide()
		$SwitchOff.show()	

func interact():
	#Change my sprite if I am called to.
	is_on = !is_on
	$Audio_Pulled.play()
	update_state()
	
func update_is_on(new_state):
	is_on = new_state
	update_state()