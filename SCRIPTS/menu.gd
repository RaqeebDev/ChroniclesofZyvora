extends Node3D

var button_type = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	button_type = "start"
	
	$Timer.start()
	$CanvasLayer/fader.show()
	$CanvasLayer/fader/Fade_timer.start()
	$buttonaudio.play()
	$CanvasLayer/fader/AnimationPlayer.play("fade_out")
	


#
#func _on_fader_fade_finished() -> void:
	#


func _on_fade_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://seens/level.tscn")
