# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Constants
const BOARD_DIMENSIONS = Vector2(8,8)
const actions = 5
const epsilon = .000001

class TreeNode:
	var children = []
	var nVisits
	var totValue
	var depth
	
	func _init():
		nVisits = 0
		totValue = 0
		
	func _ready():
		# Called when the node is added to the scene for the first time.
		# Initialization here
		pass
	
	#func _process(delta):
	#	# Called every frame. Delta is time since last frame.
	#	# Update game logic here.
	#	pass
	
	#d: depth of the node
	#md: max depth of the searc
	func selectAction(d, md):
		var visited = []
		var cur = self
		visited.append(cur)
		while !cur.isLeaf():
			cur = cur.select()
			visited.append(cur)
		cur.expand()
		var newNode = cur.select()
		visited.append(newNode)
		var value = rollOut(newNode)
		for node in visited:
			node.updateStats(value)
	
	func expand():
		children = [].resize(nActions)
		for i in nActions - 1:
			children[i] = TreeNode._init()
	
	func select():
		var selected = null
		var bestValue = -2^63
		for c in children:
			var uctValue = c.totValue / (c.nVisits + epsilon) + Math.sqrt(Math.log(nVisits+1) / (c.nVisits + epsilon)) + rand_range(0, 1) * epsilon
			if uctValue > bestValue:
				selected = c
				bestValue = uctValue
		return selected
	
	func isLeaf():
		return children == null
	
	func rollOut(tn):
		return randi_range(0, 1)
	
	func updateStats(value):
		nVisits = nVisits + 1
		totValue = totValue + value
	
	func arity():
		if children == null:
			return 0
		return children.length