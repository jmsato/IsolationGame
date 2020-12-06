extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func mcTreeSearch(rootState, itermax, verbose = false):
	var rootNode = StateNode.new(null, null, rootState)
	for i in range(1, itermax):
		var tempNode = rootNode
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
	
	return tempNode.childNodes.sort_custom(StateNode, "visits")[-1].move

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
