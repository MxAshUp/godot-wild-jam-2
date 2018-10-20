tool
extends Node2D

export var door_open : bool = false


signal interact

func _ready():
	if $AnimationPlayer and $Col:
		if door_open :
			$AnimationPlayer.play("open_door")
			$Col.set_collision_layer_bit( 0, false )

		else:
			#Door is closed.
			$AnimationPlayer.play("close_door")
			$Col.set_collision_layer_bit( 0, true )


func set_open(new_open):
	door_open = new_open
	if $AnimationPlayer and $Col:
		if door_open :
			$AnimationPlayer.play("open_door")
			$Col.set_collision_layer_bit( 0, false )

			$Audio_Close.play()
		else:
			#Door is closed.
			$AnimationPlayer.play("close_door")
			$Col.set_collision_layer_bit( 0, true )

			$Audio_Open.play()

func _on_Door_interact():
	door_open = !door_open
	set_open(door_open)