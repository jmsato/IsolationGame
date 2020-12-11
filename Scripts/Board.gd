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
var currentState
var ai : AI

var Player
var Agent

func _ready():
	generateTiles() #Generates the tiles of the board
	generatePlayers() #Generates the queen players
	Player = get_node("/root/Game/Board/QueenW")
	Agent = get_node("/root/Game/Board/QueenB")
	currentStateNode = get_node("/root/Game/CurrentState")
	ai = get_node("/root/Game/AI")
	currentState = currentStateNode.State.new()
	currentState.init()
	ai.init(currentState)
	currentPlayer = 0
	validPlayerMove = false

func _physics_process(_delta):
	#Initialize
	var player_types = [player1type, player2type]
	#Game loop
	if currentState.isUtility():
		print("End game")
		if currentState.didPlayerWin():
			print("Player won")
		else:
			print("Player lost")
		get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	else:
#		print("Current State: " + String(currentState.state))
		if player_types[currentPlayer] == player1type:
			get_tree().get_root().set_disable_input(false) #player can move during their turn
			var availableActions = currentState.getPlayerActions()
			showAvailablePlayerMoves(availableActions)
			if Input.is_action_just_pressed("ui_move"):
				print("Button pressed")
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
					hideTileShaders()
					currentPlayer = (currentPlayer + 1)
				print(currentPlayer)
		else:
			get_tree().get_root().set_disable_input(true) #player cannot move while it is the ai's turn
			print("calculating ai move")
			var moves = currentState.getAgentActions()
			var move = ai.mcTreeSearch(currentState, moves.size(), false)
			print("AI actions: " + String(moves))
			var agentTile = tiles[currentState.agentIndex]
			var xCoord = int(move % int(BOARD_DIMENSIONS.x)) * dimension
			var yCoord = int(move / BOARD_DIMENSIONS.y) * dimension
			currentState.doMove("agent", move)
			print("ai turn: " + String(move) + " xCoord: " + String(xCoord) + " yCoord: " + String(yCoord))
			agentTile.remove_piece()
			Agent.move(Vector2(xCoord, yCoord))
			currentPlayer = 0

func generateTiles():
	for y in range(BOARD_DIMENSIONS.y):
		for x in range(BOARD_DIMENSIONS.x):
			var new_tile = load("res://Scenes/Board/BoardTile.tscn").instance()
			add_child(new_tile)
			new_tile.set_tile_position(Vector2(x, y) * dimension)
			tiles.append(new_tile)

func generatePlayers():
	var white = load("res://Scenes/Queens/QueenW.tscn").instance()
	add_child(white)
	var black = load("res://Scenes/Queens/QueenB.tscn").instance()
	black.move(Vector2(7,7) * dimension)
	add_child(black)

func showAvailablePlayerMoves(availableMoves):
	for i in range(0, tiles.size()):
		if !availableMoves.has(i):
			tiles[i].get_node("Shader").visible = true

func hideTileShaders():
	for tile in tiles:
		tile.get_node("Shader").visible = false
