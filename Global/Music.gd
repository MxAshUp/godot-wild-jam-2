extends AudioStreamPlayer


#Play music lol.


func at_chase():
	self.stream = load( "res://Assets/Music/Chase.ogg" )
	self.play


func at_heroic():
	self.stream = load( "res://Assets/Music/Heroic.ogg" )
	self.play()


func _ready():
	#Play the title song.
	at_title()


func at_title():
	self.stream = load( "res://Assets/Music/Title.ogg" )
	self.play()


func at_stealth():
	self.stream = load( "res://Assets/Music/Stealth.ogg" )
	self.play()