extends Node2D
class_name TheYeyer

@onready var time_to_strike = 2
@onready var sword1: Node2D
@onready var sword2: Node2D
@onready var shield: Node2D
@onready var spot: Node2D

var tween: Tween
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()
	tween.tween_property($Sprite, 'position:y', -100, 0.8).set_trans(Tween.TRANS_SINE).as_relative()
	tween.tween_property($Sprite, 'position:y', +100, 0.8).set_trans(Tween.TRANS_SINE).as_relative()
	tween.set_loops()
	
	spot = $"../TheYeyerSpot"
	sword1 = $"../Sword1"
	sword2 = $"../Sword2"
	shield = $"../Shield"
	assert(spot and sword1 and sword2 and shield)

var speed = 120

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead: return
	var diff = spot.global_position - global_position
	if diff.length_squared() > 100:
		var dir = diff.normalized()
		position += dir * speed * delta

	$Sprite.z_index = global_position.y + 150
	time_to_strike -= delta
	if time_to_strike <=0 and not BookTrigger.Instance.locked:
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

	var diff = Player.Instance.global_position - global_position
	diff.y = 0;
	diff = diff.normalized() * 80

	if strike_tween: strike_tween.stop()
	strike_tween = create_tween()
	strike_tween.tween_property(spr, 'position', Player.Instance.global_position, 0.3)
	strike_tween.tween_callback(func(): 
		spr.queue_free();
		Player.Instance.get_node('controller').enabled = false
		get_tree().root.get_node('Simulation/Cam').add_stress(0.9)

		if TheYeyer.StrikesHitNearSwords == 0:
			if sword1.global_position.distance_to(Player.Instance.global_position) < 1200:
				print('drop the sword1!')
				sword1.get_node('AnimationPlayer').play('drop')
				TheYeyer.StrikesHitNearSwords = 1
		elif TheYeyer.StrikesHitNearSwords == 1:
			if sword2.global_position.distance_to(Player.Instance.global_position) < 700:
				print('drop the shield!')
				shield.get_node('AnimationPlayer').play('drop')
				TheYeyer.StrikesHitNearSwords = 2

	);
	strike_tween.tween_property(Player.Instance, 'position:x', diff.x, 0.2).as_relative()
	strike_tween.tween_callback(func(): 
		Player.Instance.get_node('controller').enabled = not BookTrigger.Instance.locked
	);
	strike_tween.set_loops(1)
	

var Diamond: PackedScene = preload('res://diamond.tscn')
var Tooth: PackedScene = preload('res://tooth.tscn')

func drop_loot():
	var d = Diamond.instantiate()
	var t = Tooth.instantiate()
	get_tree().root.get_node('Simulation').add_child(d)
	get_tree().root.get_node('Simulation').add_child(t)
	d.global_position = global_position + Vector2(58, 70)
	t.global_position = global_position + Vector2(-10, 0)

