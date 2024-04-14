extends Sprite2D
class_name Droplet

var t = preload("res://assets/rain.png");

var speed = 100

func _ready():
	texture = t

var dir = Vector2(-10, 14).normalized()

func _process(delta):
	position += dir * delta * speed

