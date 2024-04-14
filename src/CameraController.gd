extends Camera2D


@export var target: Node2D

func _physics_process(delta):
	if not target: return
	var target_pos = target.global_position
	var diff = target_pos - position
	const T = 0.3
	const SnapErr = 0.1
	var dist = diff.length()
	if dist <= SnapErr:
		position =target_pos 
		return
	var speed = dist / T
	position += diff.normalized() * (speed * delta)

