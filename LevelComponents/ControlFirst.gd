extends Sprite

#This node lets the game know which entity
#to control first.
#Basically just flips the entities being_controlled
#state to true after everything has been added.

func _ready():
	get_parent().being_controlled = true
	self.hide()