extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("Done").grab_focus()

func _on_Done_pressed():
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
