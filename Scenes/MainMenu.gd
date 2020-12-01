extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Grab focus as start button for keyboard input
func _ready():
	get_node("Buttons/Start").grab_focus()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
