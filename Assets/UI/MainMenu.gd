extends Node2D


#The main menu.


onready var ghost = $VBox/Ghost
 
var ghost_point : Vector2

var ghost_speed : float = 400

var current_focus = 0 #0 = Play. 1 = Quit



func _ready():
	Pause.can_pause( false )
	
	#Get offset for centering VBox.
	var center_offset : Vector2 = $VBox.rect_size
	center_offset.x /= 2
	center_offset.y /= 2
	center_offset.y -= 100
	
	
	#Place VBox in the center of the screen.
	$VBox.rect_position.y = ProjectSettings.get_setting( "display/window/size/height" ) / 2
	$VBox.rect_position.x = ProjectSettings.get_setting( "display/window/size/width" ) / 2
	$VBox.rect_position -= center_offset
	ghost.position.x = $VBox.rect_position.x + 85 
	ghost.position.y = $VBox.rect_position.y + 30
	
	
	#Put ghost at the right position.
	ghost_point = $VBox/Play/Spot.global_position
	ghost.global_position = $VBox/Play/Spot.global_position
	
	#Connect the buttons
	$VBox/Play.connect( "pressed", self, "play_pressed" )
	$VBox/Quit.connect( "pressed", self, "quit_pressed" )
	$VBox/Return.connect( "pressed", self, "return_pressed" )
	$VBox/TrueQuit.connect( "pressed", self, "true_quit_pressed" )
	
	#Start menu on Play
	$VBox/Play.grab_focus()


func play_pressed():
	#Begin the game.
	Pause.can_pause( true )
	LevelHandler.start_game()



func quit_pressed():
	#Tell ghost to move up to return
	ghost_point = $VBox/Play/Spot.global_position
	current_focus = 0
	
	
	#Bring up the popup menu.
	$VBox/Play.hide()
	$VBox/Quit.hide()
	
	
	#Remove these eventually
	$VBox/Return.show()
	$VBox/Return.grab_focus()
	$VBox/TrueQuit.show()



func _process(delta):
	if( current_focus == 0 &&
			Input.is_action_just_pressed( "ui_down" ) ):
		ghost_point = $VBox/Quit/Spot.global_position
		current_focus = 1
	
	if( current_focus == 1 &&
			Input.is_action_just_pressed( "ui_up" ) ):
		ghost_point = $VBox/Play/Spot.global_position
		current_focus = 0
	
	
	#Make the ghost particle go to ghost point
	var move : Vector2
	move = ghost_point - ghost.global_position
	move *= 3
	move = move.clamped( ghost_speed )
	ghost.global_position += move * delta


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



