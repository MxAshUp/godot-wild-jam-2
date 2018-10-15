extends AudioStreamPlayer


#Play music lol.

var last_song : AudioStream


func at_chase():
	last_song = self.stream
	self.stream = load( "res://Assets/Music/Chase.ogg" )
	self.play()


func at_heroic():
	last_song = self.stream
	self.stream = load( "res://Assets/Music/Heroic.ogg" )
	self.play()


func at_title():
	last_song = self.stream
	self.stream = load( "res://Assets/Music/Title.ogg" )
	self.play()


func at_stealth():
	last_song = self.stream
	self.stream = load( "res://Assets/Music/Stealth.ogg" )
	self.play()


func _ready():
	#Play the title song.
	at_title()
	

func revert():
	#Go to the previous song.
	if last_song != null :
		self.stream = last_song
		Music.play()
		