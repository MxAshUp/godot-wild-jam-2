extends Node2D

export var door_open : bool = false

signal interact



func _on_Door_interact():
	if door_open :
		#Close door
		door_open = false
	else:
		#open door
		door_open = true