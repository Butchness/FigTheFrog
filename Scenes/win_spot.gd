extends Area3D

@onready var meshInst = $MeshInstance3D
@onready var winSound = $AudioStreamPlayer
@onready var winSparkles = $GPUParticles3D

var up : bool = false
var length = 0

func winCon():
	winSparkles.emitting = true
	meshInst.visible = !meshInst.visible
	winSound.play()

func _process(delta):
	meshInst.rotation.y += 5 * delta
	var dist = 2 * delta
	
	if up:
		meshInst.global_position.y += dist
		length += dist
	else:
		meshInst.global_position.y -= dist
		length -= dist
	
	if length >= 3:
		up = false
	elif length <= 1:
		up = true


func _on_audio_stream_player_finished():
	queue_free()
