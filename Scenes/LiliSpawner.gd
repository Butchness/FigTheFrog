extends Node3D

@onready var collision_shape_3d = $Area3D
@onready var timer = $Timer

var liliPad = preload("res://Scenes/lilli_pad.tscn") #
var rng = RandomNumberGenerator.new()

func _ready():
	timer.start()
	spawn()

func spawn():
	var check = collision_shape_3d.get_overlapping_areas()
	var floaters = [liliPad] #array of objects that can spawn
	var floater = floaters[randi()%floaters.size()]
	var time : float = rng.randi_range(10, 50)/10
	timer.wait_time = time
	var lilis = 0
	for checks in check:
		if checks.get_parent().is_in_group("Lili"):
			lilis += 1
	if lilis == 0:
		var chance = rng.randi_range(1, 9)
		if chance%3:
			var spawnedFloater = floater.instantiate()
			add_child(spawnedFloater)

func _on_timer_timeout():
	spawn()
