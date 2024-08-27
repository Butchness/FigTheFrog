extends CharacterBody3D

@onready var part1 = $MeshInstance3D
@onready var part2 = $MeshInstance3D2
@onready var part3 = $MeshInstance3D3
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

var SPEED = 2.5
var direction = Vector3(0,0,-1)
var onLili : bool = false

func _ready():
	var parts = [part1,part2,part3]
	var colors = [Color.RED, Color.ROYAL_BLUE, Color.WEB_GREEN]
	var color = colors[randi()%colors.size()]
	
	for part in parts:
		if part.material_override is StandardMaterial3D:
			part.material_override.albedo_color = color
		else:
			var new_material = StandardMaterial3D.new()
			new_material.albedo_color = color
			part.material_override = new_material

func _process(delta):
	var face = global_transform.basis.x.normalized() * -1
	velocity = face * SPEED
	move_and_slide()
	


func _on_audio_stream_player_3d_finished():
	audio_stream_player_3d.play()


func _on_timer_timeout():
	queue_free()
