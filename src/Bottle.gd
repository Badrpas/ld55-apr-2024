extends Item
class_name Bottle


@export var ingredients: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	self.z_index = self.position.y



func get_interactable_root(): return self
	


