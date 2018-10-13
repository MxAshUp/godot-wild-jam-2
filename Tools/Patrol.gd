tool
extends Node2D

export (float) var move_speed = 100
export (float) var start_offset = 0
export (bool) var preview = false

var preview_offset = 0

func _ready():
	$Path2D/PathFollow2D.offset = start_offset

func _process(delta):
	if Engine.is_editor_hint():
		process_tool(delta)
		
	else:
		process_movement(delta)


func process_movement(delta):
	$Path2D/PathFollow2D.offset += delta * move_speed

func process_tool(delta):
	preview_offset += delta * move_speed
	if preview:
		$Path2D/PathFollow2D.offset = preview_offset + start_offset
	else:
		$Path2D/PathFollow2D.offset = start_offset
