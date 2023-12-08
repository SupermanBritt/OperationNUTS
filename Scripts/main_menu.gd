extends Node2D

# Quit Button
func _on_quit_button_pressed():
	get_tree().quit()

# Play Button
func _on_play_button_pressed():
	Global.goto_scene("res://Scenes/tutorial.tscn")
