extends Area3D

const ROCK1 = preload("res://Assets/Rocks/BigRock1.obj")
const ROCK2 = preload("res://Assets/Rocks/BigRock2.obj")
const ROCK3 = preload("res://Assets/Rocks/BigRock3.obj")
const ROCK4 = preload("res://Assets/Rocks/BigRock4.obj")

@onready var meshShape = $MeshInstance3D

func _ready():
	var rocks = [ROCK1, ROCK2, ROCK3, ROCK4]
	var rock = rocks[randi()%rocks.size()]
	meshShape.mesh = rock
