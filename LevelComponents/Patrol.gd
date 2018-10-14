tool
extends Node2D

export (float) var move_speed = 100
export (float) var start_offset = 0
export (bool) var preview = false
var preview_offset = 0
	
onready var position_follow : Position2D = get_node("PathFollow2D/Position2D") 
onready var path_follow : PathFollow2D = get_node("PathFollow2D") 
onready var path : Path2D = get_node("Path2D")

signal out_of_range

func _ready():
	if path != null:
		self.remove_child(path_follow)
		path.add_child(path_follow)
		path_follow.offset = start_offset
	else:
		set_process(false)


func get_position_follow():
	return position_follow


func _process(delta):
	if Engine.is_editor_hint():
		process_tool(delta)
		
	else:
		process_movement(delta)
	
	if path:
		pass
		#print(Vector2(path_follow.h_offset, path_follow.v_offset))


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

