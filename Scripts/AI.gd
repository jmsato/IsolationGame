extends Control

class_name AI
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

class MCTS_Node:
	var gameState: IsolationState.State
	var move
	var parentNode: MCTS_Node
	var childNodes: Array
	var value: int = 0
	var visits: int = 0
	var untriedMoves: Array
	var playerJustMoved
	
	#s: State, p: parent node
	func _init(s, p):
		gameState = s
		parentNode = p
		childNodes = []
		if s.playerJustMoved == "player":
			untriedMoves = s.getAgentActions()
		else:
			untriedMoves = s.getPlayerActions()
	
	func sortStates(sortArray):
		var arraySize = sortArray.size() - 1
		for item1 in range(arraySize):
			for item2 in range(sortArray, item1, -1):
				if sortArray[item2].visits < sortArray[item2 - 1].visits:
					var tempStore = sortArray[item2 - 1] 
					sortArray[item2 - 1] = sortArray[item2]
					sortArray[item2] = tempStore
		return sortArray
#	func clone():
#		var st = load("res://Scripts/AI.gd").MCTS_Node.new() #init()
#		st.gameState = self.gameState
#		st.move = self.move
#		st.parentNode = self.parentNode
#		st.childNodes = self.childNodes.duplicate()
#		st.value = self.value
#		st.visits = self.visits
#		st.untriedMoves = self.untriedMoves
#		st.playerJustMoved = self.playerJustMoved
#		return st
	
var isoState: IsolationState.State
var root: MCTS_Node
const epsilon = .000001

func init(state):
	isoState = state
	#isoState = get_node("/root/Root/AI").currentState
	root = MCTS_Node.new(isoState, null)

func clone():
#	var st = AI.MCTS_Node.new(self.isoState, null)
#	st.isoState = self.isoState
#	st.root = self.root
#	return st
#	var st = MCTS_Node.new(isoState, null) #init()
#	st.gameState = self.root.gameState
#	st.move = self.root.move
#	st.parentNode = self.root.parentNode
#	st.childNodes = self.root.childNodes.duplicate()
#	st.value = self.root.value
#	st.visits = self.root.visits
#	st.untriedMoves = self.root.untriedMoves
#	st.playerJustMoved = self.root.playerJustMoved
#	return st
	pass

func sortStates(sortArray):
	var arraySize = sortArray.size() - 1
	for item1 in range(arraySize):
		for item2 in range(sortArray, item1, -1):
			if sortArray[item2].visits < sortArray[item2 - 1].visits:
				var tempStore = sortArray[item2 - 1] 
				sortArray[item2 - 1] = sortArray[item2]
				sortArray[item2] = tempStore

func newNode(move = null, parent = null, state = null):
	self.root.move = move
	self.root.parentNode = parent
	self.root.childNodes = []
	self.root.value = 0
	self.root.visits = 0
	match state.playerJustMoved:
		"ai":
			self.root.untriedMoves = state.getPlayerActions()
		"player":
			self.root.untriedMoves = state.getAgentActions()
	self.root.playerJustMoved = state.playerJustMoved
	return self # may comment out later

func selectChild():
	var s = isoState.childNodes.sort()
	#var s = childNodes.sort_custom(class(StateNode), "uct")
	return s

static func uct(a, b):
	var uctA = a.value / (a.visits + epsilon) + sqrt(log(a.visits+1) / (a.visits + epsilon)) + rand_range(0, 1) * epsilon
	var uctB = b.value / (b.visits + epsilon) + sqrt(log(b.visits+1) / (b.visits + epsilon)) + rand_range(0, 1) * epsilon
	if uctA < uctB:
		return true
	return false

#static func visits(a, b):
#	if a.visits < b.visits:
#		return true
#	return false

#m: Move
#s: State (IsolationState)
func addChild(m, s):
	var n = newNode(m, self, s)
	self.root.untriedMoves.remove(self.root.untriedMoves.find(m))
	self.root.childNodes.push_back(n)
	return self.root

#result: value of the state
func updateValue(result):
	self.root.visits += 1
	self.root.value += result

func mcTreeSearch(rootState, itermax, _verbose = false):
	var rootNode = newNode(null, null, rootState) #rootState.lastPlayerMove
	var tempNode
	for _i in range(0, itermax):
		print("In for loop")
		tempNode = rootNode #rootNode.clone()
		var tempState = rootState.clone()

		#Select
		print("In select step")
		while tempNode.root.untriedMoves == [] and tempNode.root.childreNodes != []:
			tempNode = tempNode.selectChild()
			if tempNode.root.playerJustMoved == "player":
				tempState.doMove("ai", tempNode.move)
			else:
				tempState.doMove("player", tempNode.move)

		#Expand
		print("In expand step")
		if tempNode.root.untriedMoves != []:
			var m = tempNode.root.untriedMoves[randi() % tempNode.root.untriedMoves.size()]
			if tempNode.root.playerJustMoved == "player":
				tempState.doMove("ai", m)
			else:
				tempState.doMove("player", m)
			tempNode = tempNode.addChild(m, tempState)

		#Rollout
		print("In rollout step")
#		while !tempState.isUtility():
#			var actions = []
#			print("going thru rollout")
		match tempState.playerJustMoved:
			"ai":
				var actions = tempState.getPlayerActions()
				tempState.doMove("player", actions[randi() % actions.size()])
			"player":
				var actions = tempState.getAgentActions()
				tempState.doMove("ai", actions[randi() % actions.size()])
			#tempState.doMove(actions[randi() % actions.size()])

		#Backpropogate
		print("In backpropogate step")
		while tempNode.parentNode != null:
			tempNode.updateValue(tempState.getValue())
			tempNode = tempNode.parentNode
	print("returning something")
	tempNode.childNodes = tempNode.sortStates(tempNode.childNodes)
#	print(tempNode.sortStates(tempNode.childNodes))
#	print(tempNode.childNodes.sort_custom(AI.MCTS_Node, "visits"))
	return tempNode.childNodes[0].root.move#.sort()[tempNode.childNodes.size() - 1].move
	#return tempNode.childNodes.sort_custom(StateNode, "visits")[-1].move
	
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
