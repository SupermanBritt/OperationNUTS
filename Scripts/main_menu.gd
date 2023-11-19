extends Node2D

# Quit Button
func _on_quit_button_pressed():
	get_tree().quit()

# Play Button
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")
