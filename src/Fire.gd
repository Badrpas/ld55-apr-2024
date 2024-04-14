extends Sprite2D

@onready var init_position = position

var shift: Vector2 = Vector2.ZERO

var ttc = 1.0

func _process(delta):
	ttc -= delta
	if ttc > 0: return
	ttc = randf_range(0.02, 0.2)
	const R = 4
	shift = Vector2(randf_range(-R, R), randf_range(-R, R))
	position = init_position + shift
