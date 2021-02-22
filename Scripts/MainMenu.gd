extends Control

#Grab focus as start button for keyboard input
func _ready():
	get_node("Buttons/Start").grab_focus()

#Show the AI difficulty screen to start a new game
func _on_Start_pressed():
	#get_tree().change_scene("res://Scenes/Board/Board.tscn")
	get_tree().change_scene("res://Scenes/Menus/DifficultyMenu.tscn")

#Show the instructions on how to play the game
func _on_Instructions_pressed():
	get_tree().change_scene("res://Scenes/Menus/HowToPlayMenu.tscn")

#Quit and close the game
func _on_Quit_pressed():
	get_tree().quit()
