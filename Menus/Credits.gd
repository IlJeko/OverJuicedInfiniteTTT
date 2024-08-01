extends Control


func _on_credits_pressed():
	OS.shell_open("https://linktr.ee/erosruzzante")

func _on_menu_pressed():
	Transition.change_scene("res://Menus/Menu.tscn")
