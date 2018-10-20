extends Area2D


#When two talking points collide and they
#have the same talking script, they will play
#the talking script.


export var talk_scripts : PoolStringArray = PoolStringArray( [] )


export var auto_talk : PoolStringArray = PoolStringArray( [] )


#First talker to collide turns the other's can_play_talk off.
var can_play_talk = true


func _ready():
	self.connect( "area_entered", self, "attempt_talk" )
	$Talker.connect( "finished", self, "stop_talker" )
	
	for string in auto_talk:
		$Talker.stream = Music.get_talk( string )
		$Talker.play() 


func attempt_talk( area ):
	area.can_play_talk = false
	
	#If both talkers have the same talking point, start playing it.
	
	for talk in talk_scripts :
		for check_talk in area.talk_scripts :
			if talk == check_talk :
				#Play the talk script and exit loop.
				var talk_match = Music.get_talk( talk )
				$Talker.stream = talk_match
				$Talker.play()


func stop_talker():
	$Talker.stop()