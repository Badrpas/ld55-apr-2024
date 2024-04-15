extends Interactable


@onready var spot: Node2D
var tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()
	tween.tween_property($Sprite, 'position:y', -30, 0.4).set_trans(Tween.TRANS_SINE).as_relative()
	tween.tween_property($Sprite, 'position:y', +30, 0.4).set_trans(Tween.TRANS_SINE).as_relative()
	tween.set_loops()
	spot = $"../FairySpot"


var speed = 470
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var diff = spot.global_position - self.global_position
	if diff.length_squared() > 100:
		var dir = diff.normalized()
		self.position += dir * speed * delta

	$Sprite.z_index = self.global_position.y + 150


var S = preload('res://dust.tscn')
func interact(_issuer):
	var s = S.instantiate();
	get_tree().root.get_node('Simulation').add_child(s)
	s.position = self.global_position + Vector2(-10, 250)

func is_interactable(_issuer):
	var existsing = get_tree().get_nodes_in_group("dust")
	return existsing.size() < 1 


