extends Node
class_name PlayerController

@export var pawn: Node2D 
@export var speed: float = 400

var velocity: Vector2

var enabled = true

var anim: AnimationPlayer
var cam: Camera2D

func _ready():
	anim = pawn.get_node('AnimationPlayer')
	cam = get_tree().get_first_node_in_group('CAMERA')

var mouse_input: Vector2
var mouse_world: Vector2
var mouse_down = false
var mouse_down_pre = false
var just_clicked = false

func _unhandled_input(event)-> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			mouse_down = event.pressed

			if mouse_down and mouse_down_pre != mouse_down:
				just_clicked = true
				var dist = Player.Instance.get_node('eventer').interaction_marker.global_position.distance_to(mouse_world)
				if dist < 100:
					mouse_down = false
					Input.action_press('UseE')
					Input.action_release.call_deferred('UseE')

	if event is InputEventMouseMotion:
		var viewport_transform: Transform2D = get_tree().root.get_final_transform()
		mouse_input = event.xformed_by(viewport_transform).position
		mouse_world = mouse_input - get_viewport().get_visible_rect().size / 2. + cam.position


func _process(_delta)-> void:
	mouse_world = mouse_input - get_viewport().get_visible_rect().size / 2. + cam.position

	if just_clicked:
		clear_jcl.call_deferred()
	mouse_down_pre = mouse_down

func clear_jcl():
	just_clicked = false

func _physics_process(delta):
	if not pawn: return
	var dx = 0
	var dy = 0
	if mouse_down:
		dx = mouse_world.x - Player.Instance.position.x
		dy = mouse_world.y - (Player.Instance.position.y - 100)
	else:
		if Input.is_action_pressed('right'):
			dx += 1;
		if Input.is_action_pressed('left'):
			dx -= 1;
		if Input.is_action_pressed('up'):
			dy -= 1;
		if Input.is_action_pressed('down'):
			dy += 1;

	if not (dx or dy) or not enabled:
		if anim.current_animation == 'walk_2':
			anim.play('RESET', 0.5)
		return

	if not anim.is_playing() or anim.current_animation != 'walk_2':
		anim.play('walk_2')

	var dir = Vector2(dx, dy).normalized()
	velocity = dir * (speed)

	if Input.is_action_pressed('Dash'):
		velocity *= 2.


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

	
