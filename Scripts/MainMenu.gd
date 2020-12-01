extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Grab focus as start button for keyboard input
func _ready():
	get_node("Buttons/Start").grab_focus()

#Starts a new game when Start button is pressed
func _on_Start_pressed():
	$Buttons.visible = false
	$Label.visible = false

#Show the instructions on how to play the game
func _on_Instructions_pressed():
	get_tree().change_scene("res://Scenes/HowToPlayMenu.tscn")

#Quit and close the game
func _on_Quit_pressed():
	get_tree().quit()
