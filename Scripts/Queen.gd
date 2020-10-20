extends Node2D

func _ready():
	pass

func get_position():
	return position

func move(target):
	position = target