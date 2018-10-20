extends TileMap


func _ready():
	GameCamera.set_timer_time( 10 )
	GameCamera.start_timer()