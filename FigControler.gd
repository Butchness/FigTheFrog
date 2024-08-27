extends CharacterBody3D

@onready var frog = $Frog
@onready var anim = frog.get_node("AnimationPlayer")
@onready var audioPlayer = $AudioStreamPlayer
@onready var boost_timer = $BoostTimer
@onready var speed_particles = $SpeedParticles
@onready var area_3d = $Frog/Area3D
@onready var death_timer = $DeathTimer
@onready var death_sound = $DeathSound
@onready var collision_shape_3d = $CollisionShape3D
@onready var sinkSound = $AudioStreamPlayer3D
@onready var splashParticles = $splashParticles
@onready var colisionCast = $Frog/RayCast3D
@onready var winCam = $Marker3D/winCam
@onready var winRotation = $Marker3D
@onready var playerCam = $Camera3D
@onready var burnSound = $BurnSound

@export var tileDistance = 2.5 #Discrete distance for each movement
@export var moveDistance = 0

var SPEED = 10
var direction = Vector3()
var moving : bool = false #used to determine if a player is moving
var play : bool = false
var startPosition = Vector3()
var dead : bool = false
var lili : int = 0
var liliSpeed = Vector3.ZERO
var overlapping_lilipads = {}
var rot = -50

func _ready():
	colisionCast.enabled = true

func boost():
	SPEED = 20
	tileDistance = 5
	speed_particles.emitting = true
	boost_timer.start()

@warning_ignore("unused_parameter")
func _process(delta):
	if rot > -65:
		rot -= delta * 5
		playerCam.rotation_degrees.x = rot
	
	winRotation.rotation.y += 0.5 * delta
	if not moving:
		var input_vector = getAction()
		if input_vector != Vector3.ZERO:
			direction = input_vector.normalized() # Convert Vector2 to Vector3
			moving = true
			moveDistance = 0
			startPosition = position
			rotateChar(direction)
			audioPlayer.play()
	
	play = frog.playing #update the animation states
	if moving and not dead:
		check_and_sink()
	
	if dead:
		move_and_slide()
	else:
		velocity = direction * SPEED
		if lili:
			var colliders = area_3d.get_overlapping_areas()
			for colider in colliders:
				if colider.get_parent().is_in_group("Lili"):
					liliSpeed = colider.get_parent().velocity
					velocity += liliSpeed
					move_and_slide()
					break

	
	if moving:
		play = true
		moveDistance = (position - startPosition).length() # Accumulate the distance moved
		#print(moveDistance)
		move_and_slide()
		
		if moveDistance >= tileDistance:
			moving = false # Stop moving after reaching the tile distance
			direction = Vector3.ZERO
		
		if colisionCast.is_colliding():
			var collider = colisionCast.get_collider()
			if collider and collider.is_in_group("Wall"):
				moving = false
	
	if play:
		anim.play("Armature_003Action")
	else:
		anim.stop()

func getAction() -> Vector3:
	if Input.is_action_just_pressed("Left"):
		return Vector3(-1, 0, 0)
	elif Input.is_action_just_pressed("Right"):
		return Vector3(1, 0, 0)
	elif Input.is_action_just_pressed("Up"):
		return Vector3(0, 0, -1)
	elif Input.is_action_just_pressed("Down"):
		return Vector3(0, 0, 1)
	return Vector3.ZERO

func rotateChar(dir: Vector3):
	if dir != Vector3.ZERO:
		var targetPos = frog.global_transform.origin + direction
		frog.look_at(targetPos, Vector3.UP)
		frog.rotation = Vector3(0,frog.rotation.y,0)

func _on_boost_timer_timeout():
	speed_particles.emitting = false
	SPEED = 10
	tileDistance = 3

func die():
	death_sound.play()
	death_timer.start()

func sink():
	splashParticles.emitting = true
	sinkSound.play()
	death_timer.start()

func burn():
	frog.rotation = Vector3(0,-frog.rotation.y,0)
	burnSound.play()
	death_timer.start()

func check_and_sink():
	# Check if frog should sink (not on a lilipad and not dead)
	if lili <= 0:  # Check if not on a lilipad
		var colliders = area_3d.get_overlapping_areas()
		for collider in colliders:
			if collider.get_parent().is_in_group("River"):
				dead = true
				velocity = Vector3(0, -1, 0)
				sink()
				break  # No need to check further

func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var colliders = area_3d.get_overlapping_areas()
	var parent = area.get_parent()
	if parent.is_in_group("Lili"):
		if overlapping_lilipads.has(parent) == false:
			overlapping_lilipads[parent] = true
			lili += 1
	for collider in colliders:
		if collider.is_in_group("Win"):
			collider.winCon()
			winCam.current = true
			death_timer.start()
		
		if collider.is_in_group("Rock"):
			dead = true
			velocity = Vector3(0, -1, 0)
			sink()
		if collider.is_in_group("Fire"):
			dead = true
			velocity = Vector3(0, -0.5, 0)
			burn()
		if collider.get_parent().is_in_group("Car") and not dead:
			dead = true	#flag to stop from bouncing back and forth
			var deathVelocity = collider.get_parent().velocity
			velocity = deathVelocity
			area_3d.get_child(0).set("disabled", true)
			area_3d.monitoring = false
			area_3d.monitorable = false
			collision_shape_3d.disabled = true
			frog.rotation = Vector3(0,frog.rotation.z,0)
			die()

func _on_death_timer_timeout():
	get_tree().reload_current_scene()

func _on_area_3d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area:
		var parent = area.get_parent()
		if parent.is_in_group("Lili"):
			if overlapping_lilipads.has(parent):
				overlapping_lilipads.erase(parent)
				lili = max(lili - 1, 0)

func _on_splash_particles_finished():
	splashParticles.emitting = false
	velocity = Vector3.ZERO
	frog.visable = false
