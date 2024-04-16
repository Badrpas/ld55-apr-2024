extends Node2D


var time_to_strike = 8
var tween: Tween
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()
	tween.tween_property($Sprite, 'position:x', -10, 0.05).as_relative()
	tween.tween_property($Sprite, 'position:x', +10, 0.05).as_relative()
	tween.set_loops()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead: return
	time_to_strike -= delta
	if time_to_strike <=0 and not BookTrigger.Instance.locked:
		time_to_strike = 8 
		strike()

	var diff = Player.Instance.global_position - global_position

	if diff.x < 0 and scale.x < 0: scale.x *= -1
	if diff.x > 0 and scale.x > 0: scale.x *= -1

var Win = preload('res://win.tscn')
var End = preload('res://lost.tscn')

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
			strike_tween.stop()
			strike_tween = create_tween()
			strike_tween.tween_property(spr, 'position', back, 0.5)
			strike_tween.tween_callback(func(): 
				$Sprite.texture = load('res://assets/bigboy_dead.png')
				spr.queue_free();
				dead = true
			)
			strike_tween.tween_interval(3)
			strike_tween.tween_callback(func():
				var root = get_tree().root
				root.add_child(Win.instantiate())
				var sim = get_tree().get_first_node_in_group("SIMULATION")
				root.remove_child(sim)
				sim.queue_free()
			)
		else:
			spr.queue_free();
			Player.Instance.get_node('controller').enabled = false
			Player.Instance.get_node('Image').texture = load('res://assets/player_dead.png')

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
