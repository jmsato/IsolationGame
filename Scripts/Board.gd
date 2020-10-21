extends Node2D

const BOARD_DIMENSIONS = Vector2(8,8)
const dimension = 52
const player1type = 'human'
const player2type = 'ai'
var state = PoolIntArray() #Represents the 8x8 grid
var isTerminal = false

#To handle player and AI
var Player
var Agent

func _ready():
	state.resize(64) #Initializes the array of the board
	generate_tiles() #Generates the tiles of the board
	generate_players() #Generates the queen players
	Player = get_node("/root/Root/Board/QueenW")
	Agent = get_node("/root/Root/Board/QueenB")

func _physics_process(delta):
	#Initialize
	var current_player = 1
	# player_types = [player1type, player2type]
	#Game loop
	#while(!isTerminal):
	#	if player_types[current_player] == player1type:
	#		player_move()
	#		current_player =  (curent_player + 1)
	#	else:
	#		mcts()
	#		current_player =  (curent_player + 1) % 2

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

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		print("xcoord:" + str(int(event.position.x)) + "\n")
		print("ycoord:" + str(int(event.position.y)) + "\n")
		var xCoord = (int(event.position.x/dimension)) * dimension
		var yCoord = (int(event.position.y/dimension)) * dimension
		print("Move xcoord:" + str(xCoord) + "\n")
		print("Move ycoord:" + str(yCoord) + "\n")
		Player.move(Vector2(xCoord, yCoord))

func check_valid(pos):
	return true