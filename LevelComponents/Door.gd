tool
extends Node2D

export var door_open : bool = false

signal interact



func _ready():
	#Determine whether the door should be open or not.
	if door_open :
		$SpriteClosed.hide()
		$SpriteOpen.show()
		$Col.set_collision_layer_bit( 0, false )
	
	else:
		#Door is closed.
		$SpriteClosed.show()
		$SpriteOpen.hide()
		$Col.set_collision_layer_bit( 0, true )
	


func _process(delta):

		if door_open :
			$SpriteClosed.hide()
			$SpriteOpen.show()
			$Col.set_collision_layer_bit( 0, false )
	
		else:
			#Door is closed.
			$SpriteClosed.show()
			$SpriteOpen.hide()
			$Col.set_collision_layer_bit( 0, true )



func _on_Door_interact():
	if door_open :
		#Close door
		door_open = false
		$SpriteClosed.show()
		$SpriteOpen.hide()
		$Col.set_collision_layer_bit( 0, true )
	else:
		#open door
		door_open = true
		$SpriteClosed.hide()
		$SpriteOpen.show()
		$Col.set_collision_layer_bit( 0, false )




