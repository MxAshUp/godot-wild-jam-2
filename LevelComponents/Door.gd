extends StaticBody2D

export var door_open : bool = false

signal interact

func _on_Door_interact():
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