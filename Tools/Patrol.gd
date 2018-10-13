tool
extends Node2D

export (float) var move_speed = 100
export (float) var start_offset = 0
export (float) var jump_radius = 100
export (bool) var preview = false
export (bool) var being_controlled = false

onready var path_follow : PathFollow2D = get_node("PathFollow2D") 
onready var path : Path2D = get_node("Path2D")
onready var static_body : StaticBody2D = get_node("PathFollow2D/StaticBody")
onready var jump_area : Area2D = get_node("PathFollow2D/JumpArea")
onready var indicator_sprite : Sprite = get_node("PathFollow2D/IndicatorSprite")
onready var body_swap_sound : AudioStreamPlayer2D = get_node("PathFollow2D/BodySwapSound")

var collision_circle : CircleShape2D = null
var preview_offset = 0
var jumpable_bodies : Array = Array()

func _ready():
	
	# Set collision shape based on jump_radius
	collision_circle = CircleShape2D.new()
	collision_circle.radius = jump_radius
	$PathFollow2D/JumpArea/CollisionShape2D.shape = collision_circle
	
	if path != null:
		remove_child(path_follow)
		path.add_child(path_follow)
		path_follow.offset = start_offset
	
	else:
		set_process(false)


func _process(delta):
	if Engine.is_editor_hint():
		process_tool(delta)
		
	else:
		process_movement(delta)
		process_animation(delta)
		process_input(delta)


# Actual game movement
func process_movement(delta):
	path_follow.offset += delta * move_speed
	jump_area.monitoring = being_controlled


func process_input(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if jumpable_bodies.size() > 0:
			var to_jump_body : PhysicsBody2D = jumpable_bodies[0]
			to_jump_body.emit_signal("jumped", self)
			jumpable_bodies.remove(0)
			being_controlled = false


# Process for just tooling around
func process_tool(delta):
	if path_follow != null:
		preview_offset += delta * move_speed
		if preview:
			path_follow.offset = preview_offset + start_offset
			update()
		else:
			path_follow.offset = start_offset

func process_animation(delta):
	if being_controlled:
		indicator_sprite.visible = true
	else:
		indicator_sprite.visible = false


func become_controlled(jump_from : Node2D):
	being_controlled = true
	body_swap_sound.play()


func _draw():
	# Show radius of jump
	if Engine.is_editor_hint():
		draw_circle(path_follow.position, jump_radius, Color(0.5, 0.5, 0, 0.5))


func _on_JumpArea_body_entered(body : PhysicsBody2D):
	if body != self.static_body:
		var index = jumpable_bodies.find(body)
		if index == -1:
			jumpable_bodies.append(body)


func _on_JumpArea_body_exited(body):
	if body != self.static_body:
		var index = jumpable_bodies.find(body)
		if index != -1:
			jumpable_bodies.remove(index)


func _on_StaticBody_jumped(jump_from_node : Node2D):
	become_controlled(jump_from_node)