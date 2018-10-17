extends Node2D


#The main menu.


onready var ghost = $Ghost


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


func _process(delta):
	if Input.is_action_just_pressed( "ui_down" ) :
		ghost.position = $VBox.rect_position 
		ghost.position.y = ghost.position.y + 70
		ghost.position.x = ghost.position.x + 85
		
		
		
		
		
		