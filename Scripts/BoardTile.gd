extends Node2D

#When a piece is removed
signal remove_piece
#When a piece is placed
signal place_piece
#Holds the node for when a spot is taken
var TakenPiece

#Data structure for Piece node that tile is holding
var piece = {
	"exists": false,
	"piece": null #Will hold either a white piece, black piece, or taken
}

func _ready():
	pass

func get_tile_position():
	return position

func set_tile_position(new_position):
	position = new_position
	TakenPiece = get_node("X")

func remove_piece():
	piece["exists"] = true
	piece["piece"] = TakenPiece
	TakenPiece.visible=true
	emit_signal("remove_piece")

func set_piece():
	piece["exists"] = true
	piece["piece"] = TakenPiece
	TakenPiece.visible = true
	emit_signal("add_piece")