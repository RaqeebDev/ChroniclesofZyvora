extends  Area3D

@onready var mesh = get_parent().get_node("MeshInstance3D")


@onready var collision: CollisionShape3D = $"../CollisionShape3D"


func _on_body_entered(body: Node3D) -> void:
	
	await get_tree().create_timer(2.0).timeout
	collision.disabled = true
	mesh.visible = false


func _on_body_exited(body: Node3D) -> void:
	await get_tree().create_timer(2.0).timeout
	collision.disabled = false
	mesh.visible = true
