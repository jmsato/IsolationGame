class State:
	#Constants
	const BOARD_DIMENSIONS = Vector2(8,8)
	
	#Board state
	var playerIndex
	var agentIndex
	var lastPlayerMove
	var lastAgentMove
	var state = PoolIntArray() #Represents the 8x8 grid
	
	func _init(board, move, player):
		state = board.duplicate(true)
		playerIndex = board.indexOf(1) #1 represents the player
		agentIndex = board.indexOf(2) #2 represents the AI
	
	func _ready():
		pass
	
	func getBoard():
		return state
	
	#location: int
	#player: String
	func move(location, player):
		player = player.toUppercase()
		match player:
			"X":
				board[playerIndex] = 3 #Mark space as used
				board[location] = 1
				playerIndex = location
			"O":
				board[agentIndex] = 3 #Mark space as used
				board[location] = 2
				agentIndex = location
		return self
	
	func getPlayerActions():
		return getActions(playerIndex)
	
	func getOpponentActions():
		return getActions(agentIndex)
	
	func getActions(index):
		var actions = PoolIntArray()
		var columnFlag = true
		var rowFlag = true
		var diagonalNegFlag = true
		var diagonalPosFlag = true
		for i in range(index+1, BOARD_DIMENSIONS.x*BOARD_DIMENSIONS.y):
			if state[i] != 0:
				if i % BOARD_DIMENSIONS.x == index % BOARD_DIMENSIONS.x:
					columnFlag = false
				elif int(i / BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x):
					rowFlag = false
				elif int(i / BOARD_DIMENSIONS.x) - i % BOARD_DIMENSIONS.x == int(index / BOARD_DIMENSIONS.x) - index % BOARD_DIMENSIONS.x:
					diagonalNegFlag = false
				elif i == (index + (BOARD_DIMENSIONS.x - 1) * (int(i / BOARD_DIMENSIONS.x) - int(index / BOARD_DIMENSIONS.x))):
					diagonalPosFlag = false
				else:
					continue
			if i % int(BOARD_DIMENSIONS.x) == index % int(BOARD_DIMENSIONS.x) && columnFlag:
				actions.append(i)
			elif int(i / BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) && rowFlag:
				actions.append(i)
			elif int(i / BOARD_DIMENSIONS.x) - i % int(BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) - index % int(BOARD_DIMENSIONS.x) && diagonalNegFlag:
				actions.append(i)
			elif i == (index + (BOARD_DIMENSIONS.x - 1) * (int(i / BOARD_DIMENSIONS.x) - int(index / BOARD_DIMENSIONS.x))):
				actions.append(i)
		columnFlag = true
		rowFlag = true
		diagonalNegFlag = true
		diagonalPosFlag = true
		for i in range(1, index - 1):
			if state[i] != 0:
				if i % BOARD_DIMENSIONS.x == index % BOARD_DIMENSIONS.x:
					columnFlag = false
				elif int(i / BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x):
					rowFlag = false
				elif int(i / BOARD_DIMENSIONS.x) - i % BOARD_DIMENSIONS.x == int(index / BOARD_DIMENSIONS.x) - index % BOARD_DIMENSIONS.x:
					diagonalNegFlag = false
				elif i == (index + (BOARD_DIMENSIONS.x - 1) * (int(i / BOARD_DIMENSIONS.x) - int(index / BOARD_DIMENSIONS.x))):
					diagonalPosFlag = false
				else:
					continue
			if i % int(BOARD_DIMENSIONS.x) == index % int(BOARD_DIMENSIONS.x) && columnFlag:
				actions.append(i)
			elif int(i / BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) && rowFlag:
				actions.append(i)
			elif int(i / BOARD_DIMENSIONS.x) - i % int(BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) - index % int(BOARD_DIMENSIONS.x) && diagonalNegFlag:
				actions.append(i)
			elif i == (index + (BOARD_DIMENSIONS.x - 1) * (int(i / BOARD_DIMENSIONS.x) - int(index / BOARD_DIMENSIONS.x))):
				actions.append(i)
		return actions
	
	func getValue():
		var numPlayerMoves = getPlayerActions().size()
		var numAgentMoves = getAgentActions().size()
		
		var score = numPlayerMoves - numAgentMoves
		
		if(score > 5):
			score = numPlayerMoves - 2 * numAgentMoves
		elif(score < -5):
			score = 2 * numPlayerMoves - numAgentMoves
		
		return score
	
	func isUtility():
		if getPlayerActions().size() == 0 || getAgentActions().size() == 0:
			return true
		return false
