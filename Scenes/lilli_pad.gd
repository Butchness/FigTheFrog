extends CharacterBody3D

var SPEED = 2.5
var direction = Vector3(0,0,-1)

func _process(delta):
	var face = global_transform.basis.x.normalized() * -1
	velocity = face * SPEED
	move_and_slide()
