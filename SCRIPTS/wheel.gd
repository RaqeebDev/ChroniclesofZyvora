extends CanvasLayer

var spinning = false
var spin_velocity = 0.0
var friction = 0.98
var input_blocked = false

@onready var player = get_node("/root/level/player")
@onready var wheel_sprite: Sprite2D = $WheelSprite
@onready var spin_button: Button = $Button



var rewards = ["High Jump", "No Jump for 25 Seconds"]
var slice_count = rewards.size()

func _ready() -> void:
	# connect button
	spin_button.connect("pressed", Callable(self, "on_button_pressed"))

func _input(event):
	if Input.is_action_pressed("spin"):
		on_button_pressed()

func _process(delta: float) -> void:
	if spinning:
		wheel_sprite.rotation += spin_velocity * delta
		spin_velocity *= friction
		if abs(spin_velocity) < 0.01:
			spin_velocity = 0
			spinning = false
			_on_spin_finished()

func on_button_pressed():
	if input_blocked:
		return
	input_blocked = true
	spin_velocity = randf_range(200, 500)
	spinning = true

func _on_spin_finished():
	var slice_size = TAU / slice_count
	var final_angle = fposmod(wheel_sprite.rotation, TAU)
	var offset = -PI/2
	var adjusted_angle = fposmod(final_angle + offset, TAU)

	var index = int(adjusted_angle / slice_size)
	index = (slice_count - 1) - index  # reverse halves

	print("final(deg):", rad_to_deg(final_angle),
		" adj(deg):", rad_to_deg(adjusted_angle),
		" index:", index,
		" reward:", rewards[index])

	_give_reward(rewards[index])

func _give_reward(item: String) -> void:
	print("Player gets:", item)

	if item == "High Jump":
		player.jump_velocity = 6
		print("high jump")
		visible = false
		player._start_timer(25, "High Jump Active")
		await get_tree().create_timer(25.0).timeout
		player.jump_velocity = 4.8
		print("high jump over")
		input_blocked = false
		queue_free()  # removes CanvasLayer + all children (wheel, button, label)

	elif item == "No Jump for 25 Seconds":
		player.can_jump = false
		print("Jump disabled")
		visible = false
		
		player._start_timer(25, "Jump Disabled")
		await get_tree().create_timer(25.0).timeout
		player.can_jump = true
		print("Jump enabled")
		input_blocked = false
		queue_free()
		
#Count Down
