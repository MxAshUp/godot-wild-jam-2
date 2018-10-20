extends Area2D

export (String, "hostage", "guard", "jumpable") var type_needed= "jumpable"

const Hostage = preload("res://LevelComponents/Hostage.gd")
const Guard = preload("res://LevelComponents/Guard.gd")
const Jumpable = preload("res://LevelComponents/Jumpable.gd")

signal complete

func _ready():
	self.connect( "body_entered", self, "_on_body_enter" )
	self.connect( "complete", LevelHandler, "next_level" )
	

func _on_body_enter( body : KinematicBody2D ):
	if  (type_needed == "jumpable" and body is Jumpable) or (type_needed == "guard" and body is Guard) or (type_needed == "hostage" and body is Hostage):
		if (body as Jumpable).being_controlled:
			emit_signal( "complete" )
			body.emit_signal( "goal" )
			GameCamera.stop_target()