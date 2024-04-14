extends Node2D

@onready var Feather: PackedScene = preload('res://feather.tscn')
@onready var fire = get_tree().root.get_node('Simulation/Hexagram/Fire')
@onready var walk_zone: CollisionShape2D = $'../walk_area/CollisionShape2D'
@onready var target: Vector2 = position

    
var speed = 600

var playa: Player

func _ready():
    assert(fire)
    $shedding_spot.connect('body_entered', shed)


func _physics_process(delta):
    z_index = position.y - 40

    var diff = target - global_position
    var dist = diff.length_squared()
    if dist < 100: 
        if player_nearby:
            run_b(playa)
        return

    if diff.x > 0 and scale.x > 0:
        scale.x *= -1
    if diff.x < 0 and scale.x < 0:
        scale.x *= -1

    position += diff.normalized() * speed * delta

var player_nearby = false

func player_entered(body):
    if not body is Player: return;
    playa = body
    player_nearby = true
    run_b(body)
func player_exited(body):
    if not body is Player: return;
    player_nearby = false
        
func run_b(player: Player):
    var rect = walk_zone.shape.get_rect()
    rect.position += walk_zone.position
    target = player.global_position
    var diff = global_position - player.global_position
    var dir = diff.normalized()

    var move_dist = randf_range(400, 700)
    for i in range(0, 6):
        var k = 0.
        if i > 0: k = PI / (7. - i)
        for try in range(0, 4):
            target = global_position + dir.rotated(randf_range(-k, k)) * move_dist
            if rect.has_point(target):
                return
    target.x = randf_range(rect.position.x, rect.end.x)
    target.y = randf_range(rect.position.y, rect.end.y)


func shed(body):
    if not body is Player: return
    var existsing = get_tree().get_nodes_in_group("feathers")
    if existsing.size() > 1:
        return
    var f = Feather.instantiate()
    get_tree().root.get_node('Simulation').add_child.call_deferred(f)
    f.position = global_position + Vector2.UP

