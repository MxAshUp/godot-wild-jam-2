extends Area2D


signal hostage_rescued


func _ready():
	self.connect( "body_entered", self, "hostage_entered" )



func hostage_entered( body : KinematicBody2D ):
	#Hi Hostage.
	$Sprite.show() #Godot rejoices in victory.
	emit_signal( "hostage_rescued" )
	body.emit_signal( "rescued" )