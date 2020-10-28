extends Node2D

const BOARD_DIMENSIONS = Vector2(8,8)
const dimension = 52
const player1type = 'human'
const player2type = 'ai'
var state = PoolIntArray() #Represents the 8x8 grid
var isTerminal = false
var tiles = []

#To handle player and AI
var Player
var Agent

func _ready():
	state.resize(64) #Initializes the array of the board
	state[0] = 1 #Add the player to the beginning of the state
	state[63] = 2 #Add the agent to the end of the state
	generate_tiles() #Generates the tiles of the board
	generate_players() #Generates the queen players
	Player = get_node("/root/Root/Board/QueenW")
	Agent = get_node("/root/Root/Board/QueenB")

#func _physics_process(delta):
	#Initialize
#	var current_player = 1
#	var player_types = [player1type, player2type]
	#Game loop
#	while(!isTerminal):
#		if player_types[current_player] == player1type:
#			if Input.is_mouse_button_pressed(BUTTON_LEFT):
#				print("Button pressed")
#			current_player = (current_player + 1)
#		else:
#			mcts()
#			current_player = (current_player + 1) % 2

func generate_tiles():
	for y in range(BOARD_DIMENSIONS.y):
		for x in range(BOARD_DIMENSIONS.x):
			var new_tile = load("res://Scenes/BoardTile.tscn").instance()
			add_child(new_tile)
			new_tile.set_tile_position(Vector2(x, y)*dimension)
			tiles.append(new_tile)
			

func generate_players():
	var white = load("res://Scenes/QueenW.tscn").instance()
	add_child(white)
	var black = load("res://Scenes/QueenB.tscn").instance()
	black.move(Vector2(7,7)*dimension)
	add_child(black)

func _input(event):
	var playerXTile = int(Player.get_position().x/dimension)
	var playerYTile = int(Player.get_position().y/dimension)
	var playerIndex = (playerYTile*BOARD_DIMENSIONS.y)+playerXTile
	var playerTile = tiles[playerIndex]
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and playerTile.piece["piece"] == null and playerTile.piece["exists"] == false:
		var eventXTile = int(event.position.x/dimension)
		var eventYTile = int(event.position.y/dimension)
		state[playerIndex] = 2 #Mark previous tile as taken
		state[(eventYTile*BOARD_DIMENSIONS.y)+eventXTile] = 1 #Mark new tile as player
		var xCoord = eventXTile * dimension
		var yCoord = eventYTile * dimension
		#Mark the last tile as used
		playerTile.remove_piece()
		Player.move(Vector2(xCoord, yCoord))

func mcts():
	var xCoord = randi()%8
	var yCoord = randi()%8
	Agent.move(Vector2(xCoord, yCoord)*dimension)

func check_valid(pos):
	return true