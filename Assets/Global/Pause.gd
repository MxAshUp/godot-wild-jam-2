extends Node2D

#Right now, this just quits the game
#if ESC is pressed.



func can_pause( allow_pause : bool ):
	if allow_pause :
		set_process( true )
	else:
		set_process( false )


func continue_pressed():
	get_tree().paused = false
	self.hide()
	SceneBrowser.get_current_scene().show()


func _ready():
	$N/Panel/Quit.connect( "pressed", self, "quit_pressed" )
	$N/Panel/Restart.connect( "pressed", self, "restart_pressed" )
	$N/Panel/Continue.connect( "pressed", self, "continue_pressed" )


func _process( delta ):
	if Input.is_action_just_pressed( "pause" ):
		#Pause everything.
		get_tree().paused = true
		
		if self.visible == false :
			$N/Panel/Continue.grab_focus()
			self.show()
			GameCamera.set_target(self)
			SceneBrowser.get_current_scene().hide()
	
		else:
			get_tree().paused = false
			self.hide()
			SceneBrowser.get_current_scene().show()


func restart_pressed():
	self.hide()
	get_tree().paused = false
	LevelHandler.restart()


func quit_pressed():
	get_tree().quit()