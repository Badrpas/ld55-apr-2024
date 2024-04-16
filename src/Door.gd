extends Interactable


func get_interactable_root(): return self


func is_interactable(_issuer): return true


var snd_beep = preload('res://assets/sound/beep.wav')
var snd_key = preload('res://assets/sound/key.mp3')
var started = false

func interact(_issuer):
	if started: return
	if Player.Instance.holder_slot.get_child_count() == 0 or not Player.Instance.holder_slot.get_child(0) is KeyToOutside:
		get_tree().get_first_node_in_group('INTERACT_AUDIO').stream = snd_beep
		get_tree().get_first_node_in_group('INTERACT_AUDIO').play()
	else:
		started = true
		Player.Instance.get_node('controller').enabled = false
		Player.Instance.holder_slot.get_child(0).free()
		get_tree().get_first_node_in_group('INTERACT_AUDIO').stream = snd_key
		get_tree().get_first_node_in_group('INTERACT_AUDIO').play()
		var t= create_tween()
		t.tween_interval(1.3)
		t.tween_callback(func(): get_tree().change_scene_to_file.call('res://win.tscn'))

		
