extends ColorRect


@onready var animation_player: AnimationPlayer = $AnimationPlayer
signal fade_finished

func _ready() -> void:
	animation_player.animation_finished.connect(on_animation_finished)

func on_animation_finished(anim_name: String) -> void:
	emit_signal("fade_finished")


func fade_in():
	pass
	
func fade_out():
	pass	
