extends Node3D

@onready var marker_3d = $Marker3D

func _on_timer_timeout():
	marker_3d.rotation.y = randi_range(0,360)
