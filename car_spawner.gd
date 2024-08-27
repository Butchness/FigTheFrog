extends Node3D

@onready var collision_shape_3d = $Area3D
@onready var timer = $Timer

var carSlow = preload("res://Scenes/car.tscn")
var rng = RandomNumberGenerator.new()

func _ready():
	timer.start()
	spawn()

func spawn():
	var check = collision_shape_3d.get_overlapping_bodies()
	var cars = [carSlow]
	var car = cars[randi()%cars.size()]
	var time = rng.randi_range(50, 120)/10
	timer.wait_time = time
	
	if check.size() <= 0:
		var chance = rng.randi_range(1, 10)
		if chance%3:
			var spawnedCar = car.instantiate()
			add_child(spawnedCar)

func _on_timer_timeout():
	spawn()
