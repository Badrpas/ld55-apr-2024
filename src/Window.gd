extends Sprite2D
class_name WindowKek

@onready var rain_root = $rain
@onready var timer: Timer = Timer.new()

const top = -100

var tween
static var Master: WindowKek

signal kek(audio_cb);

var snd_thunder1 = preload('res://assets/sound/thunder1.mp3')
var frames = [
	preload('res://assets/window.png'),
	preload('res://assets/window-thunder.png'),
]

var thunder_tween
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)
	# timer.wait_time = 0.2
	# timer.connect('timeout', timeout)
	# timer.start()
	for i in range(10):
		add_drop()
	
	if not WindowKek.Master:
		WindowKek.Master = self
		WindowKek.Master.make_tween.call_deferred()

	WindowKek.Master.kek.connect(func(snd):
		if thunder_tween: thunder_tween.kill()
		thunder_tween = create_tween()
		thunder_tween.tween_callback(func(): texture = frames[1])
		thunder_tween.tween_interval(0.1)
		thunder_tween.tween_callback(func(): texture = frames[0])
		thunder_tween.tween_interval(0.1)
		thunder_tween.tween_callback(func(): texture = frames[1])
		thunder_tween.tween_interval(0.23)
		thunder_tween.tween_callback(func(): texture = frames[0])

		$AudioThunder.stream = snd
		$AudioThunder.play()
	)


func make_tween():
	kek.emit(snd_thunder1)
	if tween: tween.stop()
	tween = create_tween()
	var delay = randf_range(15, 33)
	print('next in ', delay)
	tween.tween_interval(delay)
	tween.tween_callback(make_tween)

func timeout():
	if rain_root.get_child_count() > 10:
		return
	add_drop()

func add_drop():
	var s = Droplet.new()
	rain_root.add_child(s)
	s.position.x = -80
	return s
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for _c in rain_root.get_children():
		var child: Node2D = _c
		if child.position.y < 0: continue
		var dist = child.position.distance_to(rain_root.position)
		if dist > 80:
			if randi_range(0, 1) == 0:
				child.position.y = top
				child.position.x = randf_range(-100, 100)
			else:
				child.position.x = -top
				child.position.y = randf_range(-100, 100)

			var k = randf_range(0.3, 1)
			child.scale = Vector2.ONE * k
			child.speed = 400 / k


