extends Node2D


func _ready():
	$AnimationPlayer.play("run")
	$AnimationPlayer2.play("running-tween")
	Music.stop()



func _on_AudioStreamPlayer_finished():
	get_tree().quit()


func _on_AnimationPlayer2_animation_finished(anim_name):
	pass
	#get_tree().quit()
