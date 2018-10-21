extends Node2D


func _ready():
	GameCamera.call_deferred( "start_intro" )