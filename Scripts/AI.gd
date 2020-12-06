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
	
var isoState: IsolationState.State
var numIterations = 1000
var root: MCTS_Node
const epsilon = .000001

func init(state):
	isoState = state
	#isoState = get_node("/root/Root/AI").currentState
	root = MCTS_Node.new(isoState, null)

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

static func visits(a, b):
	if a.visits < b.visits:
		return true
	return false

#m: Move
#s: State (IsolationState)
func addChild(m, s):
	var n = newNode(m, self, s)
	self.root.untriedMoves.remove(self.root.untriedMoves.find(m))
	self.root.childNodes.push_back(n)

#result: value of the state
func updateValue(result):
	self.root.visits += 1
	self.root.value += result

func mcTreeSearch(rootState, itermax, _verbose = false):
	var rootNode = newNode(null, null, rootState) #rootState.lastPlayerMove
	var tempNode
	for _i in range(1, itermax):
		tempNode = rootNode
		var tempState = rootState.clone()

		#Select
		while tempNode.root.untriedMoves == [] and tempNode.root.childreNodes != []:
			tempNode = tempNode.selectChild()
			if tempNode.root.playerJustMoved == "player":
				tempState.doMove("ai", tempNode.root.move)
			else:
				tempState.doMove("player", tempNode.root.move)

		#Expand
		if tempNode.root.untriedMoves != []:
			var m = tempNode.root.untriedMoves[randi() % tempNode.root.untriedMoves.size()]
			if tempNode.root.playerJustMoved == "player":
				tempState.doMove("ai", m)
			else:
				tempState.doMove("player", m)
			tempNode = tempNode.addChild(m, tempState)

		#Rollout
		while !tempState.isUtility():
			var actions = []
			match tempState.playerJustMoved:
				"ai":
					actions = tempState.getPlayerActions()
					tempState.doMove("player", actions[randi() % actions.size()])
				"player":
					actions = tempState.getAgentActions()
					tempState.doMove("ai", actions[randi() % actions.size()])
			#tempState.doMove(actions[randi() % actions.size()])

		#Backpropogate
		while tempNode != null:
			tempNode.updateValue(tempState.getValue())
			tempNode = tempNode.parentNode
	return tempNode.childNodes.sort()[-1].move
	#return tempNode.childNodes.sort_custom(StateNode, "visits")[-1].move
	
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
