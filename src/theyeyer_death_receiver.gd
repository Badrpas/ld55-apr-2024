extends Interactable







func interact(issuer):
	var sword = issuer.holder_slot.get_child(0)
	issuer.holder_slot.remove_child(sword)
	$"..".tween.stop()
	$"..".dead = true
	$"../Sprite".add_child(sword)
	sword.position = Vector2(-160, -46)
	sword.rotation = PI / -2
	sword.z_index = -1
	$"../AnimationPlayer".play('death')


func is_interactable(_issuer):
	var existsing = get_tree().get_nodes_in_group("dust")
	return existsing.size() < 1 


