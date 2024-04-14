extends Interactable

var S = preload('res://rose.tscn')

func get_interactable_root():
	return self




func interact(_issuer):
	var s = S.instantiate();
	get_tree().root.get_node('Simulation').add_child(s)
	s.position = self.global_position + Vector2(-100, 250)

func is_interactable(_issuer):
	var existsing = get_tree().get_nodes_in_group("roses")
	return existsing.size() < 1 
