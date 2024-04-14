extends Node2D

@onready var fire = get_tree().root.get_node('Simulation/Hexagram/Fire')

func _ready():
    assert(fire)
    


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    z_index = position.y - 40
