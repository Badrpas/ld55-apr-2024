extends Node2D

@onready var time_to_strike = 2
@onready var sword1: Node2D
@onready var sword2: Node2D
@onready var shield: Node2D

var tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()
	tween.tween_property($Sprite, 'position:y', -100, 0.8).set_trans(Tween.TRANS_SINE).as_relative()
	tween.tween_property($Sprite, 'position:y', +100, 0.8).set_trans(Tween.TRANS_SINE).as_relative()
	tween.set_loops()
	
	sword1 = $"../Sword1"
	sword2 = $"../Sword2"
	shield = $"../Shield"
	assert(sword1 and sword2 and shield)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite.z_index = global_position.y + 150
	time_to_strike -= delta
	if time_to_strike <=0:
		time_to_strike = 8
		strike()

static var StrikesHitNearSwords = 0

var Fireball = preload('res://assets/fireball.png')

var strike_tween: Tween
func strike():
	var spr = Sprite2D.new()
	spr.texture = Fireball
	get_tree().root.get_node('Simulation').add_child(spr)
	spr.global_position = global_position

	if strike_tween: strike_tween.stop()
	strike_tween = create_tween()
	strike_tween.tween_property(spr, 'position', Player.Instance.global_position, 0.3)
	strike_tween.tween_callback(func(): 
		Player.Instance.get_node('controller').enabled = false
		spr.queue_free();
		get_tree().root.get_node('Simulation/Cam').add_stress(0.9)
	);
	var diff = Player.Instance.global_position - global_position
	diff.y = 0;
	diff = diff.normalized() * 80
	strike_tween.tween_property(Player.Instance, 'position:x', diff.x, 0.2).as_relative()
	strike_tween.tween_callback(func(): 
		Player.Instance.get_node('controller').enabled = true
	);
	strike_tween.set_loops(1)
	


