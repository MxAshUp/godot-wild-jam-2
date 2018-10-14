tool
extends KinematicBody2D

export (float) var jump_radius = 100
export (bool) var being_controlled = false

signal jumped
signal jumped_from
signal enter_interaction_region
signal exit_interaction_region

var jump_area : Area2D
var collision_circle : CircleShape2D
var jumpable_bodies : Array = Array()
var interactables : Array = Array()
var jump_cooling_off = false
var body_swap_sound : AudioStreamPlayer2D
var selected_instance_to_jump : PhysicsBody2D


func _enter_tree():
	jump_area = Area2D.new()
	var jump_collision_shape = CollisionShape2D.new()
	jump_collision_shape.visible = false
	jump_area.add_child(jump_collision_shape)
	if Engine.is_editor_hint():
		jump_area.show_on_top = true
	add_child(jump_area)
	collision_circle = CircleShape2D.new()
	collision_circle.radius = jump_radius
	jump_collision_shape.shape = collision_circle
	body_swap_sound = AudioStreamPlayer2D.new()
	add_child(body_swap_sound)
	body_swap_sound.stream = load("res://Assets/Sounds/BodySwap.ogg")
	body_swap_sound.volume_db = -15.0 


func _exit_tree():
	if jump_area:
		remove_child(jump_area)


func _ready():
	jump_area.connect("body_entered", self, "_on_JumpArea_body_entered")
	jump_area.connect("body_exited", self, "_on_JumpArea_body_exited")
	self.connect("enter_interaction_region", self, "_on_InteractArea_area_entered")
	self.connect("exit_interaction_region", self, "_on_InteractArea_area_exited")
	self.connect("jumped", self, "_on_jumped")
	

func _process(delta):
	if being_controlled:
		process_input(delta)
	process_tool(delta)


func process_input(delta):
	if Input.is_action_just_pressed("jump") and !jump_cooling_off:
		if selected_instance_to_jump:
			being_controlled = false
			selected_instance_to_jump.emit_signal("jumped", self)
			self.emit_signal("jumped_from", selected_instance_to_jump)
		else:
			cycle_select_jump_body(0)
	
	if Input.is_action_just_pressed("interact"):
		for interactable in interactables:
			(interactable as Node).emit_signal("interact")


	if jumpable_bodies.size() > 0:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_right"):
			cycle_select_jump_body(1)
		
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left"):
			cycle_select_jump_body(-1)
		

func cycle_select_jump_body(num = 0):
	var new_index = -1
	var first_index = 0
	if num == 0:
		new_index = first_index
	else:
		if selected_instance_to_jump == null:
			new_index = first_index
		else:
			var index = jumpable_bodies.find(selected_instance_to_jump)
			if index != -1:
				new_index = int(fposmod(index + num, jumpable_bodies.size()))
			else:
				new_index = first_index
		
	if new_index == -1 or jumpable_bodies.size() == 0:
		selected_instance_to_jump = null
	else:
		selected_instance_to_jump = jumpable_bodies[new_index]


# Process for just tooling around
func process_tool(delta):
	update()


func become_controlled(jump_from : Node2D):
	being_controlled = true
	var timer = Timer.new()
	add_child(timer)
	jump_cooling_off = true
	timer.wait_time = 0.1
	timer.connect("timeout", self, "reset_jump_cooloff", [timer])
	timer.start()
	body_swap_sound.play()


func reset_jump_cooloff(timer : Timer):
	timer.queue_free()
	jump_cooling_off = false


static func is_jumpable(body : PhysicsBody2D):
	var signals = body.get_signal_list()
	for sig_obj in signals:
		if sig_obj.name == "jumped":
			return true
	return false


func _draw():
	# Show radius of jump
	if Engine.is_editor_hint() or ProjectSettings.get_setting("Global/debug_overlay"):
		draw_circle(Vector2(0,0), jump_radius, Color(0.5, 0.5, 0, 0.25))
	
	if being_controlled:
		for jumpable in jumpable_bodies:
			var jump_position = (jumpable as Node2D).global_position - global_position
			draw_circle(jump_position, 64, Color(1, 1, 1, 0.25))
			if selected_instance_to_jump == jumpable:
				draw_circle(jump_position, 64, Color(1, 1, 1, 0.25))


func _on_JumpArea_body_entered(body : PhysicsBody2D):
	if body != self and is_jumpable(body):
		var index = jumpable_bodies.find(body)
		if index == -1:
			jumpable_bodies.append(body)


func _on_JumpArea_body_exited(body : PhysicsBody2D):
	if body != self and is_jumpable(body):
		var index = jumpable_bodies.find(body)
		if index != -1:
			if selected_instance_to_jump == body:
				selected_instance_to_jump = null
				
			jumpable_bodies.remove(index)


func _on_jumped(jump_from_node : PhysicsBody2D):
	become_controlled(jump_from_node)


func _on_InteractArea_area_entered(interactable_area : Area2D):
	if interactable_area != self.jump_area:
		var index = interactables.find(interactable_area)
		if index == -1:
			interactables.append(interactable_area)


func _on_InteractArea_area_exited(interactable_area : Area2D):
	if interactable_area != self.jump_area:
		var index = interactables.find(interactable_area)
		if index != -1:
			interactables.remove(index)
