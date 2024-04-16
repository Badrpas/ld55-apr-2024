extends Node2D


var time_to_strike = 8
var tween: Tween
var dead = false
var idle_snd_tween
# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()
	tween.tween_property($Sprite, 'position:x', -10, 0.05).as_relative()
	tween.tween_property($Sprite, 'position:x', +10, 0.05).as_relative()
	tween.set_loops()
	idle_snd_tween = create_tween()
	idle_snd_tween.tween_interval(1.16)
	idle_snd_tween.tween_callback(func(): $AudioStreamPlayerLoop.play())
	idle_snd_tween.set_loops()
	$AudioStreamPlayerLoop.volume_db = -12.789
	z_index = position.y

var prepare_sound_played = false
var prepare_sound = preload('res://assets/sound/bigboy-prepare.wav')

func _process(delta):
	if dead: return
	time_to_strike -= delta
	if not prepare_sound_played and time_to_strike < 2:
		$AudioStreamPlayer.stream = prepare_sound
		$AudioStreamPlayer.play()
		prepare_sound_played = true
	if time_to_strike <=0 and not BookTrigger.Instance.locked:
		time_to_strike = 8 
		strike()

	var diff = Player.Instance.global_position - global_position

	if diff.x < 0 and scale.x < 0: scale.x *= -1
	if diff.x > 0 and scale.x > 0: scale.x *= -1

var Win = preload('res://win.tscn')
var End = preload('res://lost.tscn')

var attk_snd = preload('res://assets/sound/bigboyattk.wav')
var reflect_snd = preload('res://assets/sound/reflect.wav')
var dead_snd = preload('res://assets/sound/biboydead.wav')
var click_snd = preload('res://assets/sound/click.wav')

var Fireball = preload('res://assets/fireball.png')
var strike_tween: Tween
func strike():
	var spr = Sprite2D.new()
	spr.texture = Fireball
	get_tree().get_first_node_in_group("SIMULATION").add_child(spr)
	spr.global_position = $maw.global_position

	var back = spr.global_position

	var diff = Player.Instance.global_position - global_position
	diff.y = 0;
	diff = diff.normalized() * 80

	if strike_tween: strike_tween.stop()
	strike_tween = create_tween()
	strike_tween.tween_property(spr, 'position', Player.Instance.global_position, 0.3)
	strike_tween.tween_callback(func(): 
		# Player.Instance.get_node('controller').enabled = false
		get_tree().get_first_node_in_group("SIMULATION").get_node('Cam').add_stress(0.9)
		if Player.Instance.holder_slot.get_child(0) is Shield:
			print('relect and win')
			$AudioStreamPlayer.stream = reflect_snd
			$AudioStreamPlayer.play()
			strike_tween.stop()
			strike_tween = create_tween()
			strike_tween.tween_property(spr, 'position', back, 0.5)
			strike_tween.tween_callback(func(): 
				tween.kill()
				idle_snd_tween.kill()
				$AudioStreamPlayerLoop.stop()
				$Sprite.texture = load('res://assets/bigboy_dead.png')
				spr.queue_free();
				dead = true
				$AudioStreamPlayer.stream = dead_snd
				$AudioStreamPlayer.play()
			)
			strike_tween.tween_interval(3)
			strike_tween.tween_callback(func():
				$AudioStreamPlayer.stream = click_snd
				$AudioStreamPlayer.play()
				$Sprite.texture = load('res://assets/bigboy_dead_open.png')
				drop_loot()
			)
		
		else:
			spr.queue_free();
			Player.Instance.get_node('controller').enabled = false
			Player.Instance.get_node('Image').texture = load('res://assets/player_dead.png')
			$AudioStreamPlayer.stream = attk_snd
			$AudioStreamPlayer.play()
			idle_snd_tween.stop()
			$AudioStreamPlayerLoop.stop()

			strike_tween.stop()
			strike_tween = create_tween()
			strike_tween.tween_interval(3)
			strike_tween.tween_callback(func():
				var root = get_tree().root
				root.add_child(End.instantiate())
				var sim = get_tree().get_first_node_in_group("SIMULATION")
				root.remove_child(sim)
				sim.queue_free()
			)


	);
	strike_tween.set_loops(1)



var TheKey: PackedScene = preload('res://key.tscn')

var snd = preload('res://assets/sound/click.wav')
func drop_loot():
	var d = TheKey.instantiate()
	get_tree().get_first_node_in_group("SIMULATION").add_child(d)
	d.global_position = $loot_spot.global_position
	get_tree().get_first_node_in_group('INTERACT_AUDIO').stream = snd
	get_tree().get_first_node_in_group('INTERACT_AUDIO').play()

