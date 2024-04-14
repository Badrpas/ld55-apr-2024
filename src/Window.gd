extends Sprite2D

@onready var rain_root = $rain
@onready var timer: Timer = Timer.new()

const top = -100

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)
	# timer.wait_time = 0.2
	# timer.connect('timeout', timeout)
	# timer.start()
	for i in range(10):
		add_drop()
		


func timeout():
	if rain_root.get_child_count() > 10:
		return
	add_drop()

func add_drop():
	var s = Droplet.new()
	rain_root.add_child(s)
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


