extends Node2D

const BOARD_DIMENSIONS = Vector2(8, 8)
const dimension = 52
const player1type = 'human'
const player2type = 'ai'
var isTerminal = false
var tiles = []
var currentPlayer: int
var validPlayerMove

var currentStateNode: IsolationState
var currentState#: IsolationState.State
var ai : AI
#Board state
#var playerIndex
#var agentIndex
#var lastPlayerMove
#var lastAgentMove
#var state = [] #Represents the 8x8 grid

#To handle player and AI
#onready var Player = get_node("/root/Root/Board/Board/QueenW")
#onready var Agent = get_node("/root/Root/Board/Board/QueenB")
var Player
var Agent

var aiNode
#onready var aiNode = get_node("/root/Root/AI")
#var aiStateNode = StateNode

func _ready():
	#state.resize(64) #Initializes the array of the board
	generate_tiles() #Generates the tiles of the board
	generate_players() #Generates the queen players
	Player = get_node("/root/Game/Board/QueenW")
	Agent = get_node("/root/Game/Board/QueenB")
	currentStateNode = get_node("/root/Game/CurrentState")
	ai = get_node("/root/Game/AI")
#	Player = get_node("/root/Root/Game/Board/QueenW")
#	Agent = get_node("/root/Root/Game/Board/QueenB")
#	currentStateNode = get_node("/root/Root/Game/CurrentState")
#	ai = get_node("/root/Root/Game/AI")
	#aiNode = get_node("/root/Root/Board/Board/AI")
	#aiStateNode = get_node("/root/Root/AI")
#	state[0] = 1 #Add the player to the beginning of the state
#	state[63] = 2 #Add the agent to the end of the state
#	playerIndex = 0
#	agentIndex = 63
	currentState = currentStateNode.State.new()
	currentState.init()
	ai.init(currentState)
	currentPlayer = 0
	validPlayerMove = false
	#play_game()

func _physics_process(_delta):
	#Initialize
	#var current_player = 0
	var player_types = [player1type, player2type]
	#Game loop
	if currentState.isUtility():
		print("End game")
		get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	else:
#		print("Current State: " + String(currentState.state))
		if player_types[currentPlayer] == player1type:
			get_tree().get_root().set_disable_input(false) #player can move during their turn
			if Input.is_action_just_pressed("ui_move"):
				print("Button pressed")
				var availableActions = currentState.getPlayerActions()
				print("Player actions: " + String(availableActions))
				#var availableActions = getPlayerActions()
				var eventTileX = int(get_viewport().get_mouse_position().x / dimension)
				var eventTileY = int(get_viewport().get_mouse_position().y / dimension)
				var playerTileIndex = int(eventTileY * BOARD_DIMENSIONS.y + eventTileX)
				var playerTile = tiles[currentState.playerIndex]
				var xCoord = eventTileX * dimension
				var yCoord = eventTileY * dimension
				if(availableActions.find(playerTileIndex) >= 0):
					print("player will move")
					validPlayerMove = true
					currentState.doMove("player", playerTileIndex)
					playerTile.remove_piece()
					Player.move(Vector2(xCoord, yCoord))
				currentPlayer = (currentPlayer + 1)
				print(currentPlayer)
		else:
			get_tree().get_root().set_disable_input(true) #player cannot move while it is the ai's turn
			print("calculating ai move")
			var move = ai.mcTreeSearch(currentState, 1, false)
			var moves = currentState.getAgentActions()
			print("AI actions: " + String(moves))
#			var move = moves[randi() % moves.size()]
			var agentTile = tiles[currentState.agentIndex]
			var xCoord = int(move % int(BOARD_DIMENSIONS.x)) * dimension
			var yCoord = int(move / BOARD_DIMENSIONS.y) * dimension
			currentState.doMove("agent", move)
			print("ai turn: " + String(move) + " xCoord: " + String(xCoord) + " yCoord: " + String(yCoord))
			agentTile.remove_piece()
			Agent.move(Vector2(xCoord, yCoord))
			currentPlayer = 0 #(current_player + 1) % 2
#	pass

func generate_tiles():
	for y in range(BOARD_DIMENSIONS.y):
		for x in range(BOARD_DIMENSIONS.x):
			var new_tile = load("res://Scenes/Board/BoardTile.tscn").instance()
			add_child(new_tile)
			new_tile.set_tile_position(Vector2(x, y) * dimension)
			tiles.append(new_tile)

func generate_players():
	var white = load("res://Scenes/Queens/QueenW.tscn").instance()
	add_child(white)
	var black = load("res://Scenes/Queens/QueenB.tscn").instance()
	black.move(Vector2(7,7) * dimension)
	add_child(black)
