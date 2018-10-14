extends KinematicBody2D

export (float) var jump_radius = 100
export (bool) var being_controlled = false

#onready var body_swap_sound : AudioStreamPlayer2D = get_node("JumpSound")

signal jumped

var jump_area : Area2D
var collision_circle : CircleShape2D
var jumpable_bodies : Array = Array()
var interactables : Array = Array()


func _enter_tree():
	jump_area = Area2D.new()
	var jump_collision_shape = CollisionShape2D.new()
	jump_area.add_child(jump_collision_shape)
	add_child(jump_area)
	collision_circle = CircleShape2D.new()
	collision_circle.radius = jump_radius
	jump_collision_shape.shape = collision_circle


func _exit_tree():
	if jump_area:
		remove_child(jump_area)


func _ready():
	jump_area.connect("body_entered", self, "_on_JumpArea_body_entered")
	jump_area.connect("body_exited", self, "_on_JumpArea_body_exited")
	self.connect("jumped", self, "_on_jumped")
	self.connect("area_entered", self, "_on_InteractArea_area_entered")
	self.connect("area_exited", self, "_on_InteractArea_area_exited")
	

func _process(delta):
	if being_controlled:
		process_input(delta)
	process_tool(delta)


func process_input(delta):
	if Input.is_action_just_pressed("jump"):
		if jumpable_bodies.size() > 0:
			var to_jump_body : PhysicsBody2D = jumpable_bodies[0]
			to_jump_body.emit_signal("jumped", self)
			jumpable_bodies.remove(0)
			being_controlled = false
	
	if Input.is_action_just_pressed("interact"):
		for interactable in interactables:
			(interactable as Node).emit_signal("interact")


# Process for just tooling around
func process_tool(delta):
	update()


func become_controlled(jump_from : Node2D):
	being_controlled = true
	#body_swap_sound.play()


func _draw():
	# Show radius of jump
	if Engine.is_editor_hint():
		draw_circle(position, jump_radius, Color(0.5, 0.5, 0, 0.5))


func _on_JumpArea_body_entered(body : PhysicsBody2D):
	var index = jumpable_bodies.find(body)
	if index == -1:
		jumpable_bodies.append(body)


func _on_JumpArea_body_exited(body : PhysicsBody2D):
	var index = jumpable_bodies.find(body)
	if index != -1:
		jumpable_bodies.remove(index)


func _on_jumped(jump_from_node : Node2D):
	become_controlled(jump_from_node)


func _on_InteractArea_area_entered(interactable_area : Area2D):
	if interactable_area != jump_area:
		var index = interactables.find(interactable_area)
		if index == -1:
			interactables.append(interactable_area)


func _on_InteractArea_area_exited(interactable_area : Area2D):
	if interactable_area != self.jump_area:
		var index = interactables.find(interactable_area)
		if index != -1:
			interactables.remove(index)
