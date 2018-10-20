tool
extends Node2D

export (float) var move_speed = 100
export (float) var start_offset = 0
export (bool) var preview = false
export (bool) var persistent = false
export (bool) var ping_pong = true
export (bool) var moving = true
export (bool) var loop = true
var preview_offset = 0
	
onready var position_follow : Position2D = get_node("PathFollow2D/Position2D") 
onready var path_follow : PathFollow2D = get_node("PathFollow2D") 
onready var path : Path2D = get_node("Path2D")

signal out_of_range
signal in_range

func _ready():
	connect("out_of_range", self, "handle_out_of_range")
	connect("in_range", self, "handle_in_range")
	path_follow.loop = loop
	if path != null:
		self.remove_child(path_follow)
		path.add_child(path_follow)
		path_follow.offset = start_offset
	else:
		set_process(false)


func get_position_follow():
	return position_follow.global_position


func _process(delta):
	if ProjectSettings.get_setting("Global/debug_overlay") or Engine.is_editor_hint():
		update()
		
	if Engine.is_editor_hint():
		process_tool(delta)
		
	else:
		process_movement(delta)


# Actual game movement
func process_movement(delta):
	if moving:
		path_follow.offset += delta * move_speed


func _draw():
	if ProjectSettings.get_setting("Global/debug_overlay") or Engine.is_editor_hint():
		draw_circle(get_position_follow() - position, 20, Color(0,0.5,0,0.5))


func handle_out_of_range(follower : PhysicsBody2D):
	if ping_pong and moving:
		move_speed = -move_speed
	elif persistent == false:
		moving = false


func start_moving():
	moving = true


func stop_moving():
	moving = false


func handle_in_range(follow : PhysicsBody2D):
	pass


# Process for just tooling around
func process_tool(delta):
	update()
	if path_follow != null:
		preview_offset += delta * move_speed
		if preview:
			path_follow.offset = preview_offset + start_offset
			update()
		else:
			path_follow.offset = start_offset

