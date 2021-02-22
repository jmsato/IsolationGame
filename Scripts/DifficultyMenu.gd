extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Buttons/Easy").grab_focus()

func _on_Easy_pressed():
	get_tree().change_scene("res://Scenes/Board/Board.tscn")
	
func _on_Medium_pressed():
	get_tree().change_scene("res://Scenes/Board/Board.tscn")

func _on_Hard_pressed():
	get_tree().change_scene("res://Scenes/Board/Board.tscn")
