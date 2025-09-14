extends Node3D

var player_score = 0
var time_left: int = 30

@onready var label: Label = %Label
@onready var changelevel: Timer = $changelevel
@onready var timerlabel: Label = $timerlabel


func increase_score():
	player_score += 1
	label.text = "Score: " + str(player_score)


func do_poof(mob_position):
	const SMOKE_PUFF = preload("res://mob/smoke_puff/smoke_puff.tscn")
	var poof := SMOKE_PUFF.instantiate()
	add_child(poof)
	poof.global_position = mob_position


func _on_mob_spawner_3d_mob_spawned(mob):
	mob.died.connect(func():
		increase_score()
		do_poof(mob.global_position)
	)
	do_poof(mob.global_position)


func _on_killzone_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()


# --- TIMER LOGIC ---

func _ready() -> void:
	time_left = 30
	timerlabel.text = str(time_left)
	changelevel.start()  # Starts ticking every 1 second


func _on_changelevel_timeout() -> void:
	time_left -= 1
	timerlabel.text = str(time_left)

	if time_left <= 0:
		changelevel.stop()
		_change_scene()


func _change_scene():
	get_tree().change_scene_to_file("res://seens/level2pre.tscn")
