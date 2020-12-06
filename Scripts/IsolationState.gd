extends Node

class_name IsolationState
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

class State:
	#Board state
	var playerJustMoved
	var playerIndex
	var agentIndex
	var lastPlayerMove
	var lastAgentMove
	var state = [] #Represents the 8x8 grid
	const BOARD_DIMENSIONS = Vector2(8,8)

	func init():
		self.playerJustMoved = 'ai' #player always goes first
		self.playerIndex = 0
		self.agentIndex = 63
		self.state.resize(64)
		for i in range(1, 62):
			self.state[i] = 0
		self.state[playerIndex] = 1
		self.state[agentIndex] = 2
		self.lastPlayerMove = -1
		self.lastAgentMove = -1

	func _ready():
		# Called when the node is added to the scene for the first time.
		# Initialization here
		pass
	
	func clone():
		var st = load("res://Scripts/IsolationState.gd").State.new() #init()
		st.playerJustMoved = self.playerJustMoved
		st.playerIndex = self.playerIndex
		st.agentIndex = self.agentIndex
		st.lastPlayerMove = self.lastPlayerMove
		st.lastAgentMove = self.lastAgentMove
		st.state = self.state.duplicate(true)
		return st
	
	#player: which player is moving
	#position: position in the array the player is moving to
	func doMove(player, position):
		#player = player.toUppercase()
		match player:
			"player":
				lastPlayerMove = playerIndex
				state[playerIndex] = 3 #Mark space as used
				state[position] = 1
				playerIndex = position
				playerJustMoved = 'player'
			"agent":
				lastAgentMove = agentIndex
				state[agentIndex] = 3 #Mark space as used
				state[position] = 2
				agentIndex = position
				playerJustMoved = 'ai'
		return self
	
	func getActions(index):
		var actions = []
		var columnFlag = true
		var rowFlag = true
		var diagonalNegFlag = true
		var diagonalPosFlag = true
		for i in range(index+1, BOARD_DIMENSIONS.x*BOARD_DIMENSIONS.y):
			if state[i] != 0:
				if i % int(BOARD_DIMENSIONS.x) == index % int(BOARD_DIMENSIONS.x):
					columnFlag = false
				elif int(i / BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x):
					rowFlag = false
				elif int(i / BOARD_DIMENSIONS.x) - i % int(BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) - index % int(BOARD_DIMENSIONS.x):
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
				if i % int(BOARD_DIMENSIONS.x) == index % int(BOARD_DIMENSIONS.x):
					columnFlag = false
				elif int(i / BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x):
					rowFlag = false
				elif int(i / BOARD_DIMENSIONS.x) - i % int(BOARD_DIMENSIONS.x) == int(index / BOARD_DIMENSIONS.x) - index % int(BOARD_DIMENSIONS.x):
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
	
	func getPlayerActions():
		return getActions(playerIndex)
	
	func getAgentActions():
		return getActions(agentIndex)
	
	func isUtility():
		if getPlayerActions().size() == 0 || getAgentActions().size() == 0:
			return true
		return false
		
	func getValue():
		var numPlayerMoves = getPlayerActions().size()
		var numAgentMoves = getAgentActions().size()
		
		var score = numPlayerMoves - numAgentMoves
		
		if(score > 5):
			score = numPlayerMoves - 2 * numAgentMoves
		elif(score < -5):
			score = 2 * numPlayerMoves - numAgentMoves
		
		return score

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
