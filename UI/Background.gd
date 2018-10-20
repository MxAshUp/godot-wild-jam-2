extends Node2D

onready var path_follow = $Path2D/PathFollow2D

func _process(delta):
	path_follow.offset += delta * 20
