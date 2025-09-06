extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MAX_ACCELERATION = 2.0  # Maximum acceleration multiplier
const ACCELERATION_RATE = 0.1  # How quickly acceleration increases

@onready var pivot: Node3D = $CamOrigin
@export var Sens = 0.5

var current_acceleration = 1.0  # Current acceleration multiplier


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * Sens))
		pivot.rotate_x(deg_to_rad(-event.relative.y * Sens))
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Handle acceleration
	if direction:
		# Increase acceleration up to the limit when moving
		current_acceleration = min(current_acceleration + ACCELERATION_RATE * delta, MAX_ACCELERATION)
		velocity.x = direction.x * SPEED * current_acceleration
		velocity.z = direction.z * SPEED * current_acceleration
		$godette/AnimationPlayer.current_animation = 'Running_A'
		var target_angle = -input_dir.angle() +PI/2
		$godette.rotation.y = target_angle
		$godette.rotation.y = rotate_toward($godette.rotation.y,target_angle,6.0*delta)

	else:
		# Reset acceleration when not moving
		current_acceleration = 1.0
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		$godette/AnimationPlayer.current_animation = 'Idle'
		


	move_and_slide()
