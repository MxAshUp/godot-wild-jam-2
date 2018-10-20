extends Node2D

#Right now, this just quits the game
#if ESC is pressed.



onready var ghost_point : Vector2 = $N/Panel/Continue/Point.global_position


var ghost_speed : float = 400

onready var ghost = $N/Panel/Ghost

var current_focus = 0


#Engulfes buttons in spirit.
var juice_button = 0



func can_pause( allow_pause : bool ):
	if allow_pause :
		set_process( true )
	else:
		set_process( false )


func continue_pressed():
#	get_tree().paused = false
#	self.hide()
#	SceneBrowser.get_current_scene().show()
	unpause()
	reset_ghost()


func juice():
	juice_button = 1


func _ready():
	$N/Panel/Quit.connect( "pressed", self, "quit_pressed" )
	$N/Panel/Restart.connect( "pressed", self, "restart_pressed" )
	$N/Panel/Continue.connect( "pressed", self, "continue_pressed" )

	$N/Panel/Continue.connect( "button_down", self, "juice" )
	$N/Panel/Quit.connect( "button_down", self, "juice" )
	$N/Panel/Restart.connect( "button_down", self, "juice" )
	
	

func _process( delta ):
	if Input.is_action_just_pressed( "pause" ):
		#Pause everything.
		get_tree().paused = true
		
		if self.visible == false :
			$N/Panel/Continue.grab_focus()
			self.show()
#			GameCamera.set_target( self, Vector2(0, 30 ) )
			$Camera2D.make_current()
			SceneBrowser.get_current_scene().hide()
	
		else:
			unpause()
			#Reset ghost.
			reset_ghost()
	
	if visible == true :
		process_ghost( delta )
		
	
	
	
	
func process_ghost( delta ):
	if current_focus == 0 :
		if Input.is_action_just_pressed( "ui_down" ) :
			ghost_point = $N/Panel/Restart/Point.global_position
			current_focus += 1
			juice_button = 0
	
	elif current_focus == 1 : #On Restart.
		var move : int = int( Input.is_action_just_pressed("ui_down") ) - int( Input.is_action_just_pressed("ui_up") )
		if move == 1 : #Go down
			juice_button = 0
			current_focus = 2
			ghost_point = $N/Panel/Quit/Point.global_position
		elif move == -1 :
			current_focus = 0
			ghost_point = $N/Panel/Continue/Point.global_position
			juice_button = 0

	#Heading from quit
	
	elif current_focus == 2:
		if Input.is_action_just_pressed( "ui_up" ) :
			juice_button = 0
			current_focus = 1
			ghost_point = $N/Panel/Restart/Point.global_position
	
	#Calculate ghost movement.
	#Make the ghost particle go to ghost point
	var ghostMove : Vector2
	ghostMove = ghost_point - ghost.global_position
	ghostMove *= 3
	ghostMove = ghostMove.clamped( ghost_speed )
	ghost.global_position += ghostMove * delta
	
	
	#Juice buttons.
	if juice_button != 0 :
		if juice_button == 3 :
			ghost.get_node( "OneOne" ).emitting = true
			ghost.get_node( "OneTwo" ).emitting = true
			juice_button += 1
		elif juice_button >= 7 :
			ghost.get_node( "TwoOne" ).emitting = true
			ghost.get_node( "TwoTwo" ).emitting = true
		else:
			juice_button += 1
		
	else:
		for child in ghost.get_children() :
			child.emitting = false


func reset_ghost():
	#Put the ghost back at continue.
	var newGhostPos = $N/Panel/Continue/Point.global_position 
	ghost_point = newGhostPos
	current_focus = 0


func restart_pressed():
	reset_ghost()
	self.hide()
	get_tree().paused = false
	LevelHandler.restart()


func quit_pressed():
	get_tree().quit()
	
	
	
func unpause():
	get_tree().paused = false
	self.hide()

	$Camera2D.clear_current()
	GameCamera.make_current()
	SceneBrowser.get_current_scene().show()
	juice_button = 0