extends Node2D



func _on_main_menu_button_pressed():
	Global.goto_scene("res://Scenes/main_menu.tscn")


func _on_play_button_pressed():
	Global.goto_scene(Global.prev_path)
	

func _on_quit_button_pressed():
	get_tree().quit()


func _on_play_again_button_pressed():
	Global.goto_scene("res://Scenes/level1.tscn")
