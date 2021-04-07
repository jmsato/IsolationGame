extends Control

var game = preload("res://Scenes/Board/Board.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("Screen/Buttons/Easy").grab_focus()
	#get_node("Game").set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	print("Ignoring")
	

func _on_Easy_pressed():
#	get_node("Screen").visible = false
#	get_node("Game").visible = true
#	get_node("Game/AI").setDifficulty(1)
#	get_node("Game").set_mouse_filter(Control.MOUSE_FILTER_STOP)
#	print("Stopping")
	#get_tree().change_scene("res://Scenes/Board/Board.tscn")
	get_tree().get_root().add_child(game)
	get_node("/root/Game/AI").setDifficulty(1)
	
func _on_Medium_pressed():
	get_tree().get_root().add_child(game)
	get_node("/root/Game/AI").setDifficulty(5)
#	get_tree().change_scene("res://Scenes/Board/Board.tscn")

func _on_Hard_pressed():
	get_tree().get_root().add_child(game)
	get_node("/root/Game/AI").setDifficulty(30)
#	get_tree().change_scene("res://Scenes/Board/Board.tscn")
