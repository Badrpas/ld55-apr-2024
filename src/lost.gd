extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible = false
	$Label2.visible = false
	var t = create_tween()
	t.tween_interval(1)
	t.tween_callback(func(): $Label.visible = true; $AudioStreamPlayer.pitch_scale = 0.5; $AudioStreamPlayer.play())
	t.tween_interval(2)
	t.tween_callback(func(): $Label2.visible = true; $AudioStreamPlayer.pitch_scale = 1.5; $AudioStreamPlayer.play())
	t.tween_interval(2)
	t.tween_callback(func(): $Label3.text = '.'; $AudioStreamPlayer.pitch_scale = 1.0; $AudioStreamPlayer.play())
	t.tween_interval(1)
	t.tween_callback(func(): $Label3.text = '..'; $AudioStreamPlayer.play())
	t.tween_interval(1)
	t.tween_callback(func(): $Label3.text = '...'; $AudioStreamPlayer.play())
	t.tween_interval(1)
	t.tween_callback(func(): 
		# get_tree().change_scene_to_file('res://restart-point.tscn')
		var root = get_tree().root
		for c in root.get_children():
			root.remove_child.call_deferred(c)
		root.add_child(load('res://restart-point.tscn').instantiate())
	)


