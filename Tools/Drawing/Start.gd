extends Node2D

var pos : Vector2 = Vector2( 0,0 )


func _process( delta ):
	pos.x += 10
	pos.y += 10
	pos.x = min( pos.x, 70 )
	pos.y = min( pos.y, 70 )