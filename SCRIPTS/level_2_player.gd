extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.004
const HIT_STAGGER = 8.0
var health = 10


#signal
signal player_hit  

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

#getting gravity 
var gravity = 9.8

@onready var head = $Head
@onready var camera = $Head/Camera3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		
		velocity.y = JUMP_VELOCITY
	
	
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	
	var input_dir = Input.get_vector("right", "left", "forward", "backward")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			# stop sliding instantly when no input
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
func hit(dir):
	emit_signal("player_hit")
	velocity +=dir * HIT_STAGGER
	
	
	if Input.is_action_pressed("shoot") and  %Timer.is_stopped():
		shoot_bullet()
	
func shoot_bullet():
	const BULLETNEW_3D = preload("res://seens/bulletnew3d.tscn")
	var new_bullet = BULLETNEW_3D.instantiate()
	%Marker3D.add_child(new_bullet)

	new_bullet.global_transform = %Marker3D.global_transform
	%Timer.start()
	%AudioStreamPlayer.play()	
	
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		health -= 1
		$HealthBar.value = health
		
		if health <= 0:
			call_deferred("reload_scene")

func reload_scene():
	get_tree().reload_current_scene()
