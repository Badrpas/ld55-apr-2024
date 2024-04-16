extends Interactable

var S = preload('res://rose.tscn')

func get_interactable_root():
	return self




var snd = preload('res://assets/sound/click.wav')
func interact(_issuer):
	var s = S.instantiate();
	get_tree().get_first_node_in_group("SIMULATION").add_child(s)
	get_tree().get_first_node_in_group('INTERACT_AUDIO').stream = snd
	get_tree().get_first_node_in_group('INTERACT_AUDIO').play()
	s.position = self.global_position + Vector2(-100, 250)

func is_interactable(_issuer):
	var existsing = get_tree().get_nodes_in_group("roses")
	return existsing.size() < 1 
