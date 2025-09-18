extends Area3D

@export var wheel_scene : PackedScene
@export var checkpoint_id: int = 0
@onready var fireworks = $CPUParticles3D
@onready var label: Label = $CheckPtLabel
#var CheckPoint_number = 1
static var CheckPoint_number = 1
#@onready var wheel = get_tree().get_current_scene().get_node("wheel")




var used = true

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and used:
		fireworks.restart()
		
		#increasing score
		get_parent().get_parent().get_parent().increase_score()
		used = false
		
		show_label_temporarily(label, 3)  
		label.text = "CheckPoint %d" % CheckPoint_number
		CheckPoint_number +=1
		
		#show wheel
		var wheel_instance = wheel_scene.instantiate()
		add_child(wheel_instance)
		
		#respawn point
		body.set_checkpoint(global_transform.origin)
		
		#hide wheel ig
		await get_tree().create_timer(12.0).timeout
		wheel_instance.queue_free()
			

func show_label_temporarily(label: Label, time_sec: float) -> void:
	label.visible = true          
	await get_tree().create_timer(time_sec).timeout
	label.visible = false  
	
	
	  
