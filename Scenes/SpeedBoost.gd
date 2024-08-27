extends Node3D

@onready var collision_shape_3d = $Area
@onready var sprite_3d = $Sprite3D

signal speedPower

func _process(delta):
	var camera = get_viewport().get_camera_3d()
	if camera:
		var camera_y = camera.global_transform.basis.get_euler().x
		sprite_3d.rotation = Vector3(camera_y,0,0)


func _on_area_body_entered(body):
	var target = collision_shape_3d.get_overlapping_bodies()
	for e in target:
		if e.is_in_group("Player"):
			e.boost()
			queue_free()
