extends Control
	
	
func _ready():
	if Transition.OPlayer == true:
		$MarginContainer/VBoxContainer/Label.text = "PLAYER 1 WINS"
		$MarginContainer/VBoxContainer/Label.add_theme_color_override("font_color", Color(0.972, 0.0, 0.749))
		$WinHorn.play()
	else:
		$MarginContainer/VBoxContainer/Label.text = "PLAYER 2 WINS"
		$MarginContainer/VBoxContainer/Label.add_theme_color_override("font_color", Color(0.0, 0.972, 0.224))
		$WinHorn.play()
		
func _on_play_pressed():
	if Transition.InputEnabled:
		$ButtonClick.play()
		Transition.gameOver = false
		Transition.change_scene("res://Game/Game.tscn")

func _on_exit_pressed():
	if Transition.InputEnabled:
		$ButtonClick.play()
		await $ButtonClick.finished
		get_tree().quit()

func _on_play_button_down():
	$PlaySmoke2.emitting = true
	$PlaySmoke1.emitting = true

func _on_exit_button_down():
	$ExitSmoke2.emitting = true
	$ExitSmoke1.emitting = true
