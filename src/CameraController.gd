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



var max_offset : float = 5.0
var max_roll : float = 5.0
var shakeReduction : float = 1.3

var stress : float = 0.0
var shake : float = 0.0

func _process(_delta):  
	_process_shake(global_transform.origin, 0.0, _delta)
	
	
func _process_shake(center, angle, delta) -> void:
	shake = stress * stress
	if shake == 0:
		offset = Vector2.ZERO
		return

	rotation_degrees = angle + (max_roll * shake *  _get_noise(randi(), delta))
	
	var off = Vector2()
	off.x = (max_offset * shake * _get_noise(randi(), delta + 1.0))
	off.y = (max_offset * shake * _get_noise(randi(), delta + 2.0))
	off *= 100

	offset = off
		
	stress -= (shakeReduction / 100.0)
	
	stress = clamp(stress, 0.0, 1.0)
	
	
func _get_noise(noise_seed, time) -> float:
	var n = FastNoiseLite.new()
	
	n.seed = noise_seed
	n.fractal_octaves = 4
	# n.period = 20.0
	# n.persistence = 0.8
	
	return n.get_noise_1d(time)
	
	
func add_stress(amount : float) -> void:
	stress += amount
	stress = clamp(stress, 0.0, 1.0)
