extends Node2D

#Class variables
var nActions = 5;
var epsilon = 1e-6

class TreeNode:
	var children = []
	var nVisits
	var totValue
	
	func _ready():
		pass
	
	func selectAction():
		var visited = []
		var current = self
		visited.append(current)
		while (!current.isLeaf):
			current = current.select()
			visited.append(current)
		current.expand()
		var newNode = current.select()
		visited.append(newNode)
		var value = rollOut(newNode)
		for item in visited:
			node.updateStats(value)
			
	func expand():
		children = []
		children.resize(nActions)
		for i in range(0, nActions-1):
			children.append(i, TreeNode())
			print("in loop")
	
	func select():
		var selected = null
		var bestValue = 1e-32
		for item in children:
			var uctValue = item.totValue / (item.nVisits + epsilon) + Math.sqrt(Math.log(nVisits+1) / (c.nVisits + epsilon))
			#finish the uctValue and this