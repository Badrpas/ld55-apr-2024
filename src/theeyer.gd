extends Node2D
class_name TheYeyer

@onready var time_to_strike = 2
@onready var sword1: Node2D
@onready var sword2: Node2D
@onready var shield: Node2D
@onready var spot: Node2D


@onready var audio_loop: AudioStreamPlayer2D = $AudioStreamPlayerLoop
@onready var audio_prepare: AudioStreamPlayer2D = $AudioStreamPlayerPrepare
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
var dmg_sound = preload('res://assets/sound/explosion.wav')
var self_hit_snd = preload('res://assets/sound/yeyer-hit.wav')
var tween: Tween
var spot_tween: Tween
var dead = false

var speed = 120

static var StrikesHitNearSwords = 0

var Fireball = preload('res://assets/fireball.png')
var reflect_snd = preload('res://assets/sound/reflect.wav')

var strike_tween: Tween
var reflect_tween: Tween
var prepare_played = false

func _ready():
	tween = create_tween()
	tween.tween_property($Sprite, 'position:y', -100, 0.8).set_trans(Tween.TRANS_SINE).as_relative()
	tween.tween_callback(func(): audio_loop.play())
	tween.tween_property($Sprite, 'position:y', +100, 0.8).set_trans(Tween.TRANS_SINE).as_relative()
	tween.set_loops()
	
	spot = $"../TheYeyerSpot"
	sword1 = $"../Sword1"
	sword2 = $"../Sword2"
	shield = $"../Shield"
	assert(spot and sword1 and sword2 and shield)

func _process(delta):
	if dead: return
	var diff = spot.global_position - global_position
	if diff.length_squared() > 100:
		var dir = diff.normalized()
		position += dir * speed * delta
	elif not spot_tween:
		spot_tween = create_tween()
		spot_tween.tween_property(self, 'position:x', +150, 5).set_trans(Tween.TRANS_SINE).as_relative()
		spot_tween.tween_property(self, 'position:x', -150, 5).set_trans(Tween.TRANS_SINE).as_relative()
		spot_tween.set_loops()


	if not dead:
		$Sprite.z_index = global_position.y + 150
	time_to_strike -= delta
	if not prepare_played and time_to_strike < 0.7:
		audio_prepare.play()
		prepare_played = true
	if time_to_strike <=0 and not BookTrigger.Instance.locked:
		time_to_strike = 6 
		strike()
		prepare_played = false

func strike():
	var spr = Sprite2D.new()
	spr.texture = Fireball
	get_tree().get_first_node_in_group("SIMULATION").add_child(spr)
	spr.global_position = global_position

	var diff = Player.Instance.global_position - global_position
	diff.y = 0;
	diff = diff.normalized() * 80

	if strike_tween: strike_tween.stop()
	strike_tween = create_tween()
	strike_tween.tween_property(spr, 'position', Player.Instance.global_position, 0.3)
	strike_tween.tween_callback(func(): 
		Player.Instance.get_node('controller').enabled = false
		if Player.Instance.holder_slot.get_child(0) is Shield:
			reflect_tween = create_tween()
			reflect_tween.tween_property(spr, 'position', $Sprite/eye.global_position, 0.3)
			reflect_tween.tween_callback(func(): audio_loop.stream = self_hit_snd; audio_loop.play(); spr.queue_free(); $death_receiver.die())
			reflect_tween.set_loops(1)
			audio.stream = reflect_snd
		else:
			spr.queue_free();
			audio.stream = dmg_sound
		audio.play()
		get_tree().get_first_node_in_group("CAMERA").add_stress(0.9)

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

var snd = preload('res://assets/sound/click.wav')
func drop_loot():
	var d = Diamond.instantiate()
	var t = Tooth.instantiate()
	get_tree().get_first_node_in_group("SIMULATION").add_child(d)
	get_tree().get_first_node_in_group("SIMULATION").add_child(t)
	d.global_position = global_position + Vector2(58, 70)
	t.global_position = global_position + Vector2(-10, 0)
	get_tree().get_first_node_in_group('INTERACT_AUDIO').stream = snd
	get_tree().get_first_node_in_group('INTERACT_AUDIO').play()

