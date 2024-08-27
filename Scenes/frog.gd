extends Node3D

var playing : bool = false

func _on_animation_player_animation_finished(anim_name):
	playing = false
