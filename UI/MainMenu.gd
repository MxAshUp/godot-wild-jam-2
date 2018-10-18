extends Node2D


#The main menu.


onready var ghost = $VBox/Ghost


func _ready():
	#Get offset for centering VBox.
	var center_offset : Vector2 = $VBox.rect_size
	center_offset.x /= 2
	center_offset.y /= 2
	
	
	#Place VBox in the center of the screen.
	$VBox.rect_position.y = ProjectSettings.get_setting( "display/window/size/height" ) / 2
	$VBox.rect_position.x = ProjectSettings.get_setting( "display/window/size/width" ) / 2
	$VBox.rect_position -= center_offset
	ghost.position.x = $VBox.rect_position.x + 85 
	ghost.position.y = $VBox.rect_position.y + 30
	
	
	#Connect the buttons
	$VBox/Play.connect( "pressed", self, "play_pressed" )
	$VBox/Quit.connect( "pressed", self, "quit_pressed" )
	$VBox/Return.connect( "pressed", self, "return_pressed" )
	$VBox/TrueQuit.connect( "pressed", self, "true_quit_pressed" )
	
	#Start menu on Play
	$VBox/Play.grab_focus()


func play_pressed():
	#Begin the game.
	LevelHandler.start_game()



func quit_pressed():
	#Bring up the popup menu.
	$VBox/Play.hide()
	$VBox/Quit.hide()
	
	
	#Remove these eventually
	$VBox/Return.show()
	$VBox/Return.grab_focus()
	$VBox/TrueQuit.show()



func _process(delta):
	if Input.is_action_just_pressed( "ui_down" ) :
		ghost.position = $VBox.rect_position 
		ghost.position.y = ghost.position.y + 70
		ghost.position.x = ghost.position.x + 85
	


func return_pressed():
	#Go back to the previous menu.
	$VBox/Return.hide()
	$VBox/TrueQuit.hide()
	
	#Remove this eventually.
	$VBox/Play.show()
	$VBox/Play.grab_focus()
	$VBox/Quit.show()



func true_quit_pressed():
	get_tree().quit()



