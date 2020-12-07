extends Control

class_name AI

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
	
var isoState: IsolationState.State
var root: MCTS_Node
const epsilon = .000001

func init(state):
	isoState = state
	root = MCTS_Node.new(isoState, null)

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
	var rootNode = newNode(null, null, rootState)
	var tempNode
	for _i in range(0, itermax):
		print("In for loop")
		tempNode = rootNode 
		var tempState = rootState.clone()

		#Select
		print("In select step")
		while tempNode.root.untriedMoves == [] and tempNode.root.childrenNodes != []:
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
		match tempState.playerJustMoved:
			"ai":
				var actions = tempState.getPlayerActions()
				tempState.doMove("player", actions[randi() % actions.size()])
			"player":
				var actions = tempState.getAgentActions()
				tempState.doMove("ai", actions[randi() % actions.size()])

		#Backpropogate
		print("In backpropogate step")
		while tempNode.parentNode != null:
			tempNode.updateValue(tempState.getValue())
			tempNode = tempNode.parentNode
	print("returning something")
	tempNode.childNodes = tempNode.sortStates(tempNode.childNodes)
	return tempNode.childNodes[0].root.move
	
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
