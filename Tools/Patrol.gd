tool
extends Node2D

export (float) var move_speed = 100
export (float) var start_offset = 0
export (float) var jump_radius = 100
export (bool) var preview = false
export (bool) var being_controlled = false

onready var path_follow : PathFollow2D = get_node("PathFollow2D") 
onready var path : Path2D = get_node("Path2D")

var collision_circle : CircleShape2D = null
var preview_offset = 0

func _ready():
	
	collision_circle = CircleShape2D.new()
	collision_circle.radius = jump_radius
	$PathFollow2D/Area2D/CollisionShape2D.shape = collision_circle
	
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

# Actual game movement
func process_movement(delta):
	path_follow.offset += delta * move_speed

# Process for just tooling around
func process_tool(delta):
	if path_follow != null:
		preview_offset += delta * move_speed
		if preview:
			path_follow.offset = preview_offset + start_offset
			update()
		else:
			path_follow.offset = start_offset

func _draw():
	# Show radius of jump
	if Engine.is_editor_hint():
		draw_circle(path_follow.position, jump_radius, Color(0.5, 0.5, 0, 0.5))

func _on_Area2D_area_entered(area: Area2D):
	print(area.name)

func _on_Area2D_area_exited(area):
	pass # Replace with function body.
