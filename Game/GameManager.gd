extends TileMap

var AnimatedX
var AnimatedO
var XParticles
var OParticles
var GridSize = 3
# Dictionary containing generated cells
var Dic = {}
var textNode
var playerXmoves = []
var playerOmoves = []
var OspriteIndex = 0
var XspriteIndex = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	AnimatedO = $"../AnimatedO"
	AnimatedX = $"../AnimatedX"
	XParticles = $"../XParticles"
	OParticles = $"../OParticles"
	AnimatedO.hide()
	AnimatedX.hide()
	textNode = $"../Camera2D/Label"
	for x in GridSize:
		for y in GridSize:
			Dic[str(Vector2(x, y))] = {
				"Owner": null
			}
	Transition.OPlayer = false
	Transition.InputEnabled = true
	
func _input(event):
	if event is InputEventMouseButton and event.pressed and Transition.InputEnabled:
		var cell = local_to_map(get_global_mouse_position())
		if Dic.has(str(cell)):
			if Transition.OPlayer and Dic[str(cell)]["Owner"] == null:
				handle_oldest_cell(cell, "O", playerOmoves)
				AnimatedO.position = map_to_local(cell)
				OParticles.position = map_to_local(cell)
				AnimatedO.show()
				$"../AnimationPlayer".play('AnimationO')
				Transition.OPlayer = false
				Dic[str(cell)]["Owner"] = "O"
				Transition.InputEnabled = false
				await($"../AnimationPlayer".animation_finished)
				Transition.InputEnabled = true
				set_cell(0, cell, OspriteIndex, Vector2i(0, 0), 0)
				AnimatedO.hide()
				OParticles.emitting = true
				textNode.text = "PLAYER 1: X"
				var new_color = Color(0.282, 1.0, 0.447) # RGB values for #48ff72
				textNode.add_theme_color_override("font_color", Color(0.972, 0.0, 0.749))
				$"../PlacedSlap".play()
				if playerXmoves.size() == 3:
					var oldest_cell = playerXmoves[0]
					Dic[str(oldest_cell)]["Owner"] = null
					set_cell(0, oldest_cell, XspriteIndex+2, Vector2i(0, 0), 0) 
			elif !Transition.OPlayer and Dic[str(cell)]["Owner"] == null:
				handle_oldest_cell(cell, "X", playerXmoves)
				AnimatedX.position = map_to_local(cell)
				XParticles.position = map_to_local(cell)
				AnimatedX.show()
				$"../AnimationPlayer".play('AnimationX')
				Transition.OPlayer = true
				Dic[str(cell)]["Owner"] = "X"
				Transition.InputEnabled = false
				await($"../AnimationPlayer".animation_finished)
				Transition.InputEnabled = true
				set_cell(0, cell, XspriteIndex, Vector2i(0, 0), 0)
				AnimatedX.hide()
				XParticles.emitting = true
				textNode.text = "PLAYER 2: O"
				textNode.add_theme_color_override("font_color", Color(0.0, 0.972, 0.224))
				$"../PlacedSlap".play()
				if playerOmoves.size() == 3:
					var oldest_cell = playerOmoves[0]
					Dic[str(oldest_cell)]["Owner"] = null
					set_cell(0, oldest_cell, OspriteIndex+2, Vector2i(0, 0), 0) 
		_checkWin()

func handle_oldest_cell(cell, player, move_queue):
	if move_queue.size() >= 3:
		var oldest_cell = move_queue.pop_front()
		Dic[str(oldest_cell)]["Owner"] = null
		set_cell(0, oldest_cell, -1, Vector2i(0, 0), 0)
	move_queue.append(cell)
	Dic[str(cell)]["Owner"] = player

func _checkWin():
	for i in range(GridSize):
		if _checkLine(Vector2(i, 0), Vector2(0, 1)):  # Check column
			Transition.gameOver = true
			Transition.InputEnabled = false
			match i:
				0:
					$"../AnimationPlayer".play('WinVer1')
				1:
					$"../AnimationPlayer".play('WinVer2')
				2:
					$"../AnimationPlayer".play('WinVer3')
			return Dic[str(Vector2(i, 0))]["Owner"]
		if _checkLine(Vector2(0, i), Vector2(1, 0)):  # Check row
			Transition.gameOver = true
			Transition.InputEnabled = false
			match i:
				0:
					$"../AnimationPlayer".play('WinHor1')
				1:
					$"../AnimationPlayer".play('WinHor2')
				2:
					$"../AnimationPlayer".play('WinHor3')
			return Dic[str(Vector2(0, i))]["Owner"]
			
	if _checkLine(Vector2(0, 0), Vector2(1, 1)):  # Top-left to bottom-right diagonal
		Transition.gameOver = true
		Transition.InputEnabled = false
		$"../AnimationPlayer".play('WinDiag1')
		return Dic[str(Vector2(0, 0))]["Owner"]
	if _checkLine(Vector2(0, GridSize - 1), Vector2(1, -1)):   # Bottom-left to top-right diagonal
		Transition.gameOver = true
		Transition.InputEnabled = false
		$"../AnimationPlayer".play('WinDiag2')
		return Dic[str(Vector2(0, GridSize - 1))]["Owner"]
	
	return null  # No winner yet
			
func _checkLine(start, step):
	var cellOwner = Dic[str(start)]["Owner"]
	if cellOwner == null:
		return false
	
	for i in range(1, GridSize):
		var pos = start + step * i
		if Dic[str(pos)]["Owner"] != cellOwner:
			return false
	
	return true

func _on_animation_player_animation_finished(_anim_name):
	if Transition.gameOver:
		Transition.change_scene("res://Menus/GameOver.tscn") # Replace with function body.
