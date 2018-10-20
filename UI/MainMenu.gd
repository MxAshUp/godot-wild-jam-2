extends Node2D


#The main menu.


onready var ghost = $CanvasLayer/Center/VBox/Center/Ghost
onready var vbox = $CanvasLayer/Center/VBox
onready var button_play = $CanvasLayer/Center/VBox/Center/VBox_Menu/Play
onready var button_quit = $CanvasLayer/Center/VBox/Center/VBox_Menu/Quit
onready var play_spot = $CanvasLayer/Center/VBox/Center/VBox_Menu/Play/Spot
onready var quit_spot = $CanvasLayer/Center/VBox/Center/VBox_Menu/Quit/Spot
onready var reveal = $CanvasLayer/Reveal
 
var ghost_point : Vector2

var ghost_speed : float = 400

var current_focus = 0 #0 = Play. 1 = Quit



func _ready():
	Pause.can_pause( false )
	Music.at_title()
	
	
	#Put ghost at the right position.
	ghost_point = play_spot.global_position
	ghost.global_position = ghost_point
	
	#Connect the buttons
	button_play.connect( "pressed", self, "play_pressed" )
	button_quit.connect( "pressed", self, "quit_pressed" )
	#$VBox/Return.connect( "pressed", self, "return_pressed" )
	#$VBox/TrueQuit.connect( "pressed", self, "true_quit_pressed" )
	
	#Start menu on Play
	button_play.grab_focus()


func play_pressed():
	#Begin the game.
	Pause.can_pause( true )
	LevelHandler.start_game()



func quit_pressed():
	#DIE PROGRAM!!!!!!!
	get_tree().quit()
	
	#Tell ghost to move up to return
#	ghost_point = play_spot.global_position
#	current_focus = 0
#
#
#	#Bring up the popup menu.
#	button_play.hide()
#	button_quit.hide()
	
	
	#Remove these eventually
	#$VBox/Return.show()
	#$VBox/Return.grab_focus()
	#$VBox/TrueQuit.show()



func _process(delta):
	if( current_focus == 0 &&
			Input.is_action_just_pressed( "ui_down" ) ):
		ghost_point = quit_spot.global_position
		current_focus = 1
	
	if( current_focus == 1 &&
			Input.is_action_just_pressed( "ui_up" ) ):
		ghost_point = play_spot.global_position
		current_focus = 0
	
	
	#Make the ghost particle go to ghost point
	var move : Vector2
	move = ghost_point - ghost.global_position
	move *= 3
	move = move.clamped( ghost_speed )
	ghost.global_position += move * delta
	
	
	#Make reveal fade away
	if reveal.modulate.a > 0 :
		reveal.modulate.a -= delta / 5


func return_pressed():
	#Go back to the previous menu.
#	$VBox/Return.hide()
#	$VBox/TrueQuit.hide()
	
	#Remove this eventually.
	button_play.show()
	button_play.grab_focus()
	button_quit.show()



func true_quit_pressed():
	get_tree().quit()



