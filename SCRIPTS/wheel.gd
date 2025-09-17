extends Sprite2D

var spinning = false
var spin_velocity = 0.0
var friction = 0.98



@onready var player = get_node("/root/level/player")
@onready var wheel = get_node("/root/level/wheel")

var rewards = ["High Jump", "No Jump for 25 Seconds"]
var slice_count = rewards.size()

func _ready() -> void:
	centered = true
	$"../Button".connect("pressed", Callable(self, "on_button_pressed"))


func _input(event):
	if Input.is_action_pressed("spin"):
		on_button_pressed()

func _process(delta: float) -> void:
	if spinning:
		rotation += spin_velocity * delta
		spin_velocity *= friction
		if abs(spin_velocity) < 0.01:
			spin_velocity = 0
			spinning = false
			_on_spin_finished()

func on_button_pressed():
	spin_velocity = randf_range(200, 500)
	spinning = true

func _on_spin_finished():
	var slice_size = TAU / slice_count
	var final_angle = fposmod(rotation, TAU)
	var offset = -PI/2
	var adjusted_angle = fposmod(final_angle + offset, TAU)

	var index = int(adjusted_angle / slice_size)

	# ---- FIX: reverse mapping so it's not opposite ----
	index = (slice_count - 1) - index   # swap halves

	print("final(deg):", rad_to_deg(final_angle), 
		  " adj(deg):", rad_to_deg(adjusted_angle), 
		  " index:", index, 
		  " reward:", rewards[index])

	_give_reward(rewards[index])
	

func _give_reward(item: String) -> void:
	print("Player gets:", item)
	
	
	#add wheel.visible = false

	if item == "High Jump":
		player.jump_velocity = 6
		await get_tree().create_timer(25.0).timeout
		player.jump_velocity = 4.8
		
	elif item == "No Jump for 25 Seconds":
		player.can_jump = false
		
		await get_tree().create_timer(25.0).timeout
		player.can_jump = true
		
