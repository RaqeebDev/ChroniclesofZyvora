extends MeshInstance3D

@export var rotation_minutes := 3.0 # 1 full rotation every 3 minutes

func _process(delta: float) -> void:
	var deg_per_sec = 360.0 / (rotation_minutes * 60.0)
	rotate_y(deg_to_rad(deg_per_sec) * delta)
