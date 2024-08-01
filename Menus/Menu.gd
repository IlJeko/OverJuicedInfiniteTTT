extends Control

func _on_play_pressed():
	if Transition.InputEnabled:
		$AudioStreamPlayer.play()
		Transition.change_scene("res://Game/Game.tscn")
	
func _on_exit_pressed():
	if Transition.InputEnabled:
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
		get_tree().quit()
	
func _on_play_button_down():
	$PlaySmoke2.emitting = true
	$PlaySmoke1.emitting = true

func _on_exit_button_down():
	$ExitSmoke2.emitting = true
	$ExitSmoke1.emitting = true

func _on_credits_pressed():
	Transition.change_scene("res://Menus/Credits.tscn")
	$AudioStreamPlayer.play()
