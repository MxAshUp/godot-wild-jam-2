extends Node2D

var pos : Vector2 = Vector2( 50,50 )


func _process( delta ):
	pos.x += 10
	pos.y += 10