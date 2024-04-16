extends Node

@export var pawn: Node2D 
@export var speed: float = 400

var velocity: Vector2

var enabled = true

var anim: AnimationPlayer
func _ready():
	anim = pawn.get_node('AnimationPlayer')

func _physics_process(delta):
	if not enabled: return
	if not pawn: return
	var dx = 0
	var dy = 0
	if Input.is_action_pressed('right'):
		dx += 1;
	if Input.is_action_pressed('left'):
		dx -= 1;
	if Input.is_action_pressed('up'):
		dy -= 1;
	if Input.is_action_pressed('down'):
		dy += 1;

	if not (dx or dy):
		if anim.current_animation == 'walk_2':
			anim.play('RESET', 0.5)
		return

	if not anim.is_playing() or anim.current_animation != 'walk_2':
		anim.play('walk_2')

	var dir = Vector2(dx, dy).normalized()
	velocity = dir * (speed)


	var image: Node2D = pawn.get_node_or_null('Image');
	if image:
		if dx > 0 and image.scale.x < 0:
			image.scale.x *= -1
		if dx < 0 and image.scale.x > 0:
			image.scale.x *= -1

	if pawn is CharacterBody2D:
		var c: CharacterBody2D = pawn;
		c.velocity = velocity
		c.move_and_slide()
		velocity = Vector2.ZERO
	else:
		pawn.position += velocity * delta 
		print('boba no charactedbody2d')

	
