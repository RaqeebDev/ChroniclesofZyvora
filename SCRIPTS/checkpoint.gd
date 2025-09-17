extends Area3D

@export var checkpoint_id: int = 0
@onready var fireworks = $CPUParticles3D
@onready var label: Label = $CheckPtLabel

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		fireworks.restart()
		label.visible = true
		body.set_checkpoint(global_transform.origin)
		
