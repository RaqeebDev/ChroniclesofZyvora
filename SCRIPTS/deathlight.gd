extends Area3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	var current = body
	while current != null and not (current is CharacterBody3D):
		current = current.get_parent()
	
	if current != null and current.has_method("respawn"):
		#print("yessir")
		current.respawn()




#stream paused sir : ) 
