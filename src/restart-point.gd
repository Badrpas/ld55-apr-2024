extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_parent()
	var s = $Simulation
	remove_child(s)
	root.remove_child.call_deferred(self)
	root.add_child.call_deferred(s)
	queue_free()

