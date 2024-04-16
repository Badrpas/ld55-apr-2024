extends Item
class_name Bottle


@export var ingredients: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	self.z_index = self.position.y



func get_interactable_root(): return self
	
func interact(_from):
	var ap: AnimationPlayer = get_tree().get_first_node_in_group('CAULDRON').get_node('AnimationPlayer')
	ap.stop(true)
	super(_from)

