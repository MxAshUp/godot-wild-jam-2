extends Area2D

#A scene which all interactable objects
#should use. It handles all interact logic.
#When this scene gets an interact signal emitted
#it will pass it on to children.

signal interact

func _ready():
	self.connect("body_entered", self, "_on_InteractArea_body_entered")
	self.connect("body_exited", self, "_on_InteractArea_body_exited")
	self.connect("interact", self, "_on_Interactable_interact")


func _on_Interactable_interact():
	for child in get_children():
		(child as Node).emit_signal("interact")
		

static func is_interactable(area : Area2D):
	var signals = area.get_signal_list()
	for sig_obj in signals:
		if sig_obj.name == "interact":
			return true
	return false


func _on_InteractArea_body_entered(body : PhysicsBody2D):
	body.emit_signal("enter_interaction_region", self)


func _on_InteractArea_body_exited(body : PhysicsBody2D):
	body.emit_signal("exit_interaction_region", self)