extends CanvasLayer

var OPlayer
var InputEnabled = true
var gameOver = false

func change_scene(target: String):
	if gameOver:
		$Explosions.emitting = true
		$Explosions2.emitting = true
		$AnimationPlayer.play('dissolve_slow')
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file(target)
		$AnimationPlayer.play_backwards('dissolve_slow')
		InputEnabled = true
	else:
		$AnimationPlayer.play('dissolve')
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file(target)
		$AnimationPlayer.play_backwards('dissolve')
		InputEnabled = true
		
func _process(delta):
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
