extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label2.visible = false
	var t = create_tween()
	t.tween_interval(1)
	t.tween_callback(func(): $Label2.visible = true)
	t.tween_interval(2)
	t.tween_callback(func(): $Label3.text = '.')
	t.tween_interval(1)
	t.tween_callback(func(): $Label3.text = '..')
	t.tween_interval(1)
	t.tween_callback(func(): $Label3.text = '...')
	t.tween_interval(1)
	t.tween_callback(func(): 
		# get_tree().change_scene_to_file('res://restart-point.tscn')
		var root = get_tree().root
		for c in root.get_children():
			root.remove_child.call_deferred(c)
		root.add_child(load('res://restart-point.tscn').instantiate())
	)


