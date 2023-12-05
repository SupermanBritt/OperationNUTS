extends Node2D

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
