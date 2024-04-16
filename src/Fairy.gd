extends Interactable


@onready var spot: Node2D
var tween: Tween

var cycles = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()
	tween.tween_property($Sprite, 'position:y', -30, 0.4).set_trans(Tween.TRANS_SINE).as_relative()
	tween.tween_property($Sprite, 'position:y', +30, 0.4).set_trans(Tween.TRANS_SINE).as_relative()
	tween.tween_callback(func():
		cycles += 1;
		print('cycle ', cycles)
		if cycles > 1: 
			$AudioStreamPlayer2D.play()
			cycles = 0
	)
	tween.set_loops()
	if get_tree().get_nodes_in_group('FAIRY').size() > 1:
		spot = get_tree().get_first_node_in_group("SIMULATION").get_node("FairySpotFallback")
	else:
		spot = get_tree().get_first_node_in_group("SIMULATION").get_node("FairySpot")


var speed = 470
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var diff = spot.global_position - self.global_position
	if diff.length_squared() > 100:
		var dir = diff.normalized()
		self.position += dir * speed * delta

	$Sprite.z_index = self.global_position.y + 150


var snd = preload('res://assets/sound/click.wav')
var S = preload('res://dust.tscn')
func interact(_issuer):
	var s = S.instantiate();
	get_tree().get_first_node_in_group('SIMULATION').add_child(s)
	get_tree().get_first_node_in_group('INTERACT_AUDIO').stream = snd
	get_tree().get_first_node_in_group('INTERACT_AUDIO').play()
	s.position = self.global_position + Vector2(-10, 250)

func is_interactable(_issuer):
	var existsing = get_tree().get_nodes_in_group("dust")
	return existsing.size() < 1 


