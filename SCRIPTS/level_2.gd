extends Node3D
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
#
#
#func _on_portal_body_entered(body: Node3D) -> void:
	#body.call_deferred("queue_free")
	
	
	


func _on_portal_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		call_deferred("_change_scene")

func _change_scene() -> void:
	get_tree().change_scene_to_file("res://seens/dummy.tscn")
