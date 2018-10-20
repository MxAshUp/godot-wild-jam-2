tool
extends Node2D


var frame_wait : int = 6

#Random affects
var min_range = -0.1
var max_range = 0.1

onready var color_start = $Light2D.color.a


func _process(delta):
	if frame_wait == 0:
		frame_wait = 6
		
		#Flicker baby.
		var rand = rand_range( min_range, max_range )
		$Light2D.color.a = color_start + rand
		
		update()
		
	
	else:
		frame_wait -= 1


		
		
		
		
		
		
		
		
		
		
		
		
		
		