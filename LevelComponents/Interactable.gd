extends Area2D

#A scene which all interactable objects
#should use. It handles all interact logic.
#When this scene gets an interact signal emitted
#it will pass it on to children.

signal interact

func _on_Interactable_interact():
	for child in get_children():
		(child as Node).emit_signal("interact")