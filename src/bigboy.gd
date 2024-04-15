extends Node2D


var tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()
	tween.tween_property($Sprite, 'position:x', -10, 0.1).as_relative()
	tween.tween_property($Sprite, 'position:x', +10, 0.1).as_relative()
	tween.set_loops()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
