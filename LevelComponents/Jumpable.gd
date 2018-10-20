tool
extends KinematicBody2D

export (float) var jump_radius = 100
export (bool) var being_controlled = false

signal jumped
signal jumped_noargs
signal jumped_from
signal jumped_from_noargs
signal enter_interaction_region
signal exit_interaction_region
signal becoming_jumped
signal cancelled_jump

var jump_area : Area2D
var collision_circle : CircleShape2D
var jumpable_bodies : Array = Array()
var interactables : Array = Array()
var jump_cooling_off = false
var sound_swap_charge : AudioStreamPlayer2D
var body_swap_sound : AudioStreamPlayer2D
var selected_instance_to_jump : PhysicsBody2D

var being_jumped = false
var trying_to_jump = false
var jump_charge : float = 0
const JUMP_CHARGE_REACH = 0.7 # seconds to hold jump to jump
var BecomingControlledParticles = preload("res://LevelComponents/BecomingControlled.tscn")
var jump_to_particle_emitter = BecomingControlledParticles.instance()

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
	# Sound for jump charging
	sound_swap_charge = AudioStreamPlayer2D.new()
	add_child(sound_swap_charge)
	sound_swap_charge.stream = load("res://Assets/Sounds/Swapping.ogg")
	sound_swap_charge.volume_db = linear2db(0)
	sound_swap_charge.play()
	add_child(jump_to_particle_emitter)
	# Sound for jump complete
	body_swap_sound = AudioStreamPlayer2D.new()
	add_child(body_swap_sound)
	body_swap_sound.stream = load("res://Assets/Sounds/BodySwap.ogg")
	jump_to_particle_emitter.emitting = false
	add_child(jump_to_particle_emitter)


func _exit_tree():
	if jump_area:
		remove_child(jump_area)
	remove_child(jump_to_particle_emitter)


func _ready():
	#Have the game camera focus on me,
	#if level starts controlling with controlling me.
	if being_controlled :
		GameCamera.set_target( self, true )
	
	jump_area.connect("body_entered", self, "_on_JumpArea_body_entered")
	jump_area.connect("body_exited", self, "_on_JumpArea_body_exited")
	self.connect("enter_interaction_region", self, "_on_InteractArea_area_entered")
	self.connect("exit_interaction_region", self, "_on_InteractArea_area_exited")
	self.connect("jumped", self, "_on_jumped")
	self.connect("becoming_jumped", self, "_on_becoming_jumped")
	self.connect("cancelled_jump", self, "_on_cancelled_jump")
	

func _process(delta):
	if being_controlled:
		process_input(delta)
	process_tool(delta)
	sound_swap_charge.volume_db = linear2db(jump_charge)


func process_input(delta):
	jump_to_particle_emitter.emitting = false
	
	if Input.is_action_just_pressed("jump") and being_controlled:
		trying_to_jump = true
		
	if Input.is_action_just_released("jump") and being_controlled:
		trying_to_jump = false
		if selected_instance_to_jump:
			selected_instance_to_jump.emit_signal("cancelled_jump", self)
	
	
	if trying_to_jump and !jump_cooling_off and jumpable_bodies.size() > 0:
		if !selected_instance_to_jump:
			jump_charge = 0
			selected_instance_to_jump = get_closest_jumpable_index()
			
		if selected_instance_to_jump:
			jump_charge += delta
			jump_to_particle_emitter.emitting = true
			jump_to_particle_emitter.position = selected_instance_to_jump.global_position - global_position
			selected_instance_to_jump.emit_signal("becoming_jumped", self)
			if jump_charge > JUMP_CHARGE_REACH:
				jump_charge = 0
				jump_to_particle_emitter.emitting = false
				trying_to_jump = false
				being_controlled = false
				selected_instance_to_jump.emit_signal("jumped", self)
				selected_instance_to_jump.emit_signal("jumped_noargs")
				self.emit_signal("jumped_from", selected_instance_to_jump)
				self.emit_signal("jumped_from_noargs")
				body_swap_sound.play()
				
	else:
		jump_charge = 0
	
	if Input.is_action_just_pressed("interact"):
		for interactable in interactables:
			(interactable as Node).emit_signal("interact")


func get_closest_jumpable_index():
	
	var closest_distance = jump_radius * 2
	var closest_body = null
	for body in jumpable_bodies:
		var dis = ((body as Node2D).global_position - global_position).length()
		if dis < closest_distance:
			closest_distance = dis
			closest_body = body
	
	return closest_body

# Process for just tooling around
func process_tool(delta):
	update()


func become_controlled(jump_from : Node2D):
	being_controlled = true
	being_jumped = false
	var timer = Timer.new()
	add_child(timer)
	jump_cooling_off = true
	timer.wait_time = 0.1
	timer.connect("timeout", self, "reset_jump_cooloff", [timer])
	timer.start()
	body_swap_sound.play()
	
	#Add a camera here and see if everything goes smoothly.
	GameCamera.set_target( self )


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
	
#	if being_controlled:
#		for jumpable in jumpable_bodies:
#			var jump_position = (jumpable as Node2D).global_position - global_position
#			draw_circle(jump_position, 64, Color(1, 1, 1, 0.25))
#			if selected_instance_to_jump == jumpable:
#				draw_circle(jump_position, 64, Color(1, 1, 1, 0.25))


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
				if trying_to_jump:
					selected_instance_to_jump.emit_signal("cancelled_jump", self)
				selected_instance_to_jump = null
				
			jumpable_bodies.remove(index)


func _on_jumped(jump_from_node : PhysicsBody2D):
	become_controlled(jump_from_node)


func _on_becoming_jumped(jump_from_node : PhysicsBody2D):
	being_jumped = true
	
	
func _on_cancelled_jump(jump_from_node : PhysicsBody2D):
	being_jumped = false


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
