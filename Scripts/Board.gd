extends Node2D

const BOARD_DIMENSIONS = Vector2(8, 8)
const dimension = 52
const player1type = 'human'
const player2type = 'ai'
var isTerminal = false
var tiles = []

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
	Player = get_node("/root/Root/Board/Board/QueenW")
	Agent = get_node("/root/Root/Board/Board/QueenB")
	currentStateNode = get_node("/root/Root/Board/CurrentState")
	ai = get_node("/root/Root/Board/AI")
	#aiNode = get_node("/root/Root/Board/Board/AI")
	#aiStateNode = get_node("/root/Root/AI")
#	state[0] = 1 #Add the player to the beginning of the state
#	state[63] = 2 #Add the agent to the end of the state
#	playerIndex = 0
#	agentIndex = 63
	currentState = currentStateNode.State.new()
	currentState.init()
	ai.init(currentState)
	play_game()

func _physics_process(_delta):
	#Initialize
#	var current_player = 0
#	var player_types = [player1type, player2type]
#	#Game loop
#	#while(true):
#	if player_types[current_player] == player1type:
#		if Input.is_action_just_pressed("ui_move"):
#			print("Button pressed")
#			var availableActions = getPlayerActions()
#			var eventTileX = int(get_viewport().get_mouse_position().x / dimension)
#			var eventTileY = int(get_viewport().get_mouse_position().y / dimension)
#			if(availableActions.find(int(eventTileY * BOARD_DIMENSIONS.y + eventTileX)) >= 0):
#				print("player will move")
#			current_player = (current_player + 1)
#	else:
#		#mcts() # currently moves to a random spot
#		current_player = 0 #(current_player + 1) % 2
	pass

func generate_tiles():
	for y in range(BOARD_DIMENSIONS.y):
		for x in range(BOARD_DIMENSIONS.x):
			var new_tile = load("res://Scenes/Board/BoardTile.tscn").instance()
			add_child(new_tile)
			new_tile.set_tile_position(Vector2(x, y) * dimension)
			tiles.append(new_tile)
			#state[BOARD_DIMENSIONS.x * y + x] = 0
			

func generate_players():
	var white = load("res://Scenes/Queens/QueenW.tscn").instance()
	add_child(white)
	var black = load("res://Scenes/Queens/QueenB.tscn").instance()
	black.move(Vector2(7,7) * dimension)
	add_child(black)
#	var ai = load("res://Scenes/AI.tscn").instance()
#	add_child(ai)

func play_game():
	#var gameState = aiNode._init()
	#var gameStateNode = aiStateNode.newNode(null, null, gameState)
	#var gameStateNode = aiStateNode._ready(null, null, gameState)
	var move
#	while !gameState.isUtility():
#		if gameState.playerJustMoved == 2:
#			move = gameStateNode.mcTreeSearch(gameState, 100, false)
#			gameState.doMove("agent", move)
#			print(move)
#		else:
#			move = 1
#			gameState.doMove("player", move)
	while !currentState.isUtility():
		if currentState.playerJustMoved == "player":
			move = ai.mcTreeSearch(currentState, 100, false)
			currentState.doMove("agent", move)
			print(move)
		else:
			move = 1
			currentState.doMove("player", move)

#func _input(event):
#	var playerXTile = int(Player.get_position().x / dimension)
#	var playerYTile = int(Player.get_position().y / dimension)
#	var playerIndex = (playerYTile * BOARD_DIMENSIONS.y) + playerXTile
#	var playerTile = tiles[playerIndex]
#	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed and playerTile.piece["piece"] == null and playerTile.piece["exists"] == false:
#		var eventXTile = int(event.position.x / dimension)
#		var eventYTile = int(event.position.y / dimension)
#		state[playerIndex] = 2 #Mark previous tile as taken
#		state[(eventYTile * BOARD_DIMENSIONS.y) + eventXTile] = 1 #Mark new tile as player
#		var xCoord = eventXTile * dimension
#		var yCoord = eventYTile * dimension
#		#Mark the last tile as used
#		playerTile.remove_piece()
#		Player.move(Vector2(xCoord, yCoord))

#func mcts():
#	var xCoord = randi() % BOARD_DIMENSIONS.x
#	var yCoord = randi() % BOARD_DIMENSIONS.x
#	Agent.move(Vector2(xCoord, yCoord) * dimension)

#func isValidMove(pos):
#	return state[pos] == 0 or state[pos] == null
#
#func getValue():
#	var numPlayerMoves = getPlayerActions().size()
#	var numAgentMoves = getAgentActions().size()
#
#	var score = numPlayerMoves - numAgentMoves
#
#	if(score > 5):
#		score = numPlayerMoves - 2 * numAgentMoves
#	elif(score < -5):
#		score = 2 * numPlayerMoves - numAgentMoves
#
#	return score
#
#func getActions(index):
#	var actions = []
#	var columnFlag = true
#	var rowFlag = true
#	var diagonalNegFlag = true
#	var diagonalPosFlag = true
#	for i in range(index+1, BOARD_DIMENSIONS.x*BOARD_DIMENSIONS.y):
#		if state[i] != 0:
#			if i % int(BOARD_DIMENSIONS.x) == index % int(BOARD_DIMENSIONS.x):
#				columnFlag = false
#			elif int(i / BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x):
#				rowFlag = false
#			elif int(i / BOARD_DIMENSIONS.x) - i % int(BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) - index % int(BOARD_DIMENSIONS.x):
#				diagonalNegFlag = false
#			elif i == (index + (BOARD_DIMENSIONS.x - 1) * (int(i / BOARD_DIMENSIONS.x) - int(index / BOARD_DIMENSIONS.x))):
#				diagonalPosFlag = false
#			else:
#				continue
#		if i % int(BOARD_DIMENSIONS.x) == index % int(BOARD_DIMENSIONS.x) && columnFlag:
#			actions.append(i)
#		elif int(i / BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) && rowFlag:
#			actions.append(i)
#		elif int(i / BOARD_DIMENSIONS.x) - i % int(BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) - index % int(BOARD_DIMENSIONS.x) && diagonalNegFlag:
#			actions.append(i)
#		elif i == (index + (BOARD_DIMENSIONS.x - 1) * (int(i / BOARD_DIMENSIONS.x) - int(index / BOARD_DIMENSIONS.x))):
#			actions.append(i)
#	columnFlag = true
#	rowFlag = true
#	diagonalNegFlag = true
#	diagonalPosFlag = true
#	for i in range(1, index - 1):
#		if state[i] != 0:
#			if i % int(BOARD_DIMENSIONS.x) == index % int(BOARD_DIMENSIONS.x):
#				columnFlag = false
#			elif int(i / BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x):
#				rowFlag = false
#			elif int(i / BOARD_DIMENSIONS.x) - i % int(BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) - index % int(BOARD_DIMENSIONS.x):
#				diagonalNegFlag = false
#			elif i == (index + (BOARD_DIMENSIONS.x - 1) * (int(i / BOARD_DIMENSIONS.x) - int(index / BOARD_DIMENSIONS.x))):
#				diagonalPosFlag = false
#			else:
#				continue
#		if i % int(BOARD_DIMENSIONS.x) == index % int(BOARD_DIMENSIONS.x) && columnFlag:
#			actions.append(i)
#		elif int(i / BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) && rowFlag:
#			actions.append(i)
#		elif int(i / BOARD_DIMENSIONS.x) - i % int(BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) - index % int(BOARD_DIMENSIONS.x) && diagonalNegFlag:
#			actions.append(i)
#		elif i == (index + (BOARD_DIMENSIONS.x - 1) * (int(i / BOARD_DIMENSIONS.x) - int(index / BOARD_DIMENSIONS.x))):
#			actions.append(i)
#	return actions
#
#func getPlayerActions():
#	return getActions(playerIndex)
#
#func getAgentActions():
#	return getActions(agentIndex)
#
#func isUtility():
#	if getPlayerActions().size() == 0 || getAgentActions().size() == 0:
#		return true
#	return false
