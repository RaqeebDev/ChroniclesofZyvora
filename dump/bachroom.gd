extends Node3D

@export var room_scene: PackedScene
@export var grid_size_x: int = 5
@export var grid_size_z: int = 5
@export var room_size: float = 10.0

func _ready():
	generate_maze()

func generate_maze():
	randomize()
	for x in range(grid_size_x):
		for z in range(grid_size_z):
			var room = room_scene.instantiate()
			room.position = Vector3(x * room_size, 0, z * room_size)
			add_child(room)

			# Randomly remove some walls inside the room
			_randomize_walls(room)

func _randomize_walls(room: Node3D):
	# This assumes your walls are named wall1, wall2, wall3, wall4
	# Delete some walls to open passages
	for wall_name in ["wall1", "wall2", "wall3", "wall4"]:
		if randf() < 0.4:  # 40% chance to remove a wall
			var wall = room.get_node_or_null(wall_name)
			if wall:
				wall.queue_free()
