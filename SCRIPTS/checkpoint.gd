extends Area3D

@export var checkpoint_id: int = 0

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.set_checkpoint(global_transform.origin)
