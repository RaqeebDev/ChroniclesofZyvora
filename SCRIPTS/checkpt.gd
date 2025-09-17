extends Area3D

@export var checkpoint_id: int = 0
@onready var fireworks = $CPUParticles3D
@onready var label: Label = $CheckPtLabel
#var CheckPoint_number = 1
static var CheckPoint_number = 1


@onready var wheel = get_tree().get_current_scene().get_node("wheel")




var used = true

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and used:
		fireworks.restart()
		used = false
		
		show_label_temporarily(label, 3)  
		label.text = "CheckPoint %d" % CheckPoint_number
		CheckPoint_number +=1
		
		#show wheel
		wheel.visible = true
		
		
		body.set_checkpoint(global_transform.origin)
			

func show_label_temporarily(label: Label, time_sec: float) -> void:
	label.visible = true          
	await get_tree().create_timer(time_sec).timeout
	label.visible = false  
	
	
	  
