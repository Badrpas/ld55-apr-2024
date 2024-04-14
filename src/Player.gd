extends Node2D
class_name Player


@onready var holder_slot: Node2D = $'Image/holder_slot'

static var Instance: Player

func _ready():
    Instance = self

