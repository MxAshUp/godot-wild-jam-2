extends Node2D

#Right now, this just quits the game
#if ESC is pressed.


func continue_pressed():
	get_tree().paused = false
	self.hide()


func _ready():
	$Panel/Quit.connect( "pressed", self, "quit_pressed" )
	$Panel/Restart.connect( "pressed", self, "restart_pressed" )
	$Panel/Continue.connect( "pressed", self, "continue_pressed" )


func _process( delta ):
	if Input.is_action_just_pressed( "pause" ):
		#Pause everything.
		get_tree().paused = true
		
		if self.visible == false :
			$Panel/Quit.grab_focus()
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