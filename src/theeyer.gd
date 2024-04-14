extends Node2D

@onready var time_to_strike = 4

var tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()
	tween.tween_property($Sprite, 'position:y', -100, 0.8).set_trans(Tween.TRANS_SINE).as_relative()
	tween.tween_property($Sprite, 'position:y', +100, 0.8).set_trans(Tween.TRANS_SINE).as_relative()
	tween.set_loops()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite.z_index = global_position.y + 150
	time_to_strike -= delta
	if time_to_strike <=0:
		time_to_strike = 8
		strike()


func strike():
	pass
