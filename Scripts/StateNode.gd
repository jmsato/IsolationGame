extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
class StateNode:
	var move
	var parentNode
	var childNodes
	var wins
	var visits
	var untriedMoves
	var playerJustMoved
	const epsilon = .000001
	
	func _ready(move = null, parent = null, state = null):
		# Called when the node is added to the scene for the first time.
		# Initialization here
		self.move = move
		self.parentNode = parent
		self.childNodes = []
		self.wins = 0
		self.visits = 0
		match state.playerJustMoved:
			"ai":
				self.untriedMoves = state.getPlayerActions()
			"player":
				self.untriedMoves = state.getAgentActions()
		self.playerJustMoved = state.playerJustMoved
	
	func newNode(move = null, parent = null, state = null):
		self.move = move
		self.parentNode = parent
		self.childNodes = []
		self.wins = 0
		self.visits = 0
		match state.playerJustMoved:
			"ai":
				self.untriedMoves = state.getPlayerActions()
			"player":
				self.untriedMoves = state.getAgentActions()
		self.playerJustMoved = state.playerJustMoved
	
	func selectChild():
		var s = childNodes.sort()
		#var s = childNodes.sort_custom(class(StateNode), "uct")
		return s
	
	static func uct(a, b):
		var uctA = a.wins / (a.visits + epsilon) + sqrt(log(a.visits+1) / (a.visits + epsilon)) + rand_range(0, 1) * epsilon
		var uctB = b.wins / (b.visits + epsilon) + sqrt(log(b.visits+1) / (b.visits + epsilon)) + rand_range(0, 1) * epsilon
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
		var n = _ready(m, self, s)
		self.untriedMoves.remove(self.untriedMoves.find(m))
		self.childNodes.push_back(n)
	
	#result: value of the state
	func update(result):
		self.visits += 1
		self.wins += result
	
	func mcTreeSearch(rootState, itermax, verbose = false):
		var rootNode = StateNode.init(null, null, rootState)
		var tempNode
		for i in range(1, itermax):
			tempNode = rootNode
			var tempState = rootState.clone()

			#Select
			while tempNode.untriedMoves == [] and tempNode.childreNodes != []:
				tempNode = tempNode.selectChild()
				if tempNode.playerJustMoved == "player":
					tempState.doMove("ai", tempNode.move)
				else:
					tempState.doMove("player", tempNode.move)

			#Expand
			if tempNode.untriedMoves != []:
				var m = tempNode.untriedMoves[randi() % tempNode.untriedMoves.size()]
				if tempNode.playerJustMoved == "player":
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
					"player":
						actions = tempState.getAgentActions()
				tempState.doMove(actions[randi() % actions.size()])

			#Backpropogate
			while tempNode != null:
				tempNode.update(tempState.getValue())
				tempNode = tempNode.parentNode
		return tempNode.childNodes.sort()[-1].move
		#return tempNode.childNodes.sort_custom(StateNode, "visits")[-1].move
