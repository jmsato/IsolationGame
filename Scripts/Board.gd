extends Node2D

const BOARD_DIMENSIONS = Vector2(8,8)
const dimension = 52
var state = PoolIntArray() #Represents the 8x8 grid

func _ready():
	state.resize(64) #Initializes the array of the board
	generate_tiles()
	generate_players()

func generate_tiles():
	for x in range(BOARD_DIMENSIONS.x):
		for y in range(BOARD_DIMENSIONS.y):
			var new_tile = load("res://Scenes/BoardTile.tscn").instance()
			add_child(new_tile)
			new_tile.set_tile_position(Vector2(x, y)*dimension)
			
func generate_players():
	var white = load("res://Scenes/QueenW.tscn").instance()
	add_child(white)
	var black = load("res://Scenes/QueenB.tscn").instance()
	black.move(Vector2(7,7)*dimension)
	add_child(black)
	
func check_valid(pos):
	
	return true