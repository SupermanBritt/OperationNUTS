extends Node2D

func _on_play_button_pressed():
	Global.goto_scene("res://Scenes/level1.tscn")


func _on_back_button_pressed():
	Global.goto_scene("res://Scenes/main_menu.tscn")
