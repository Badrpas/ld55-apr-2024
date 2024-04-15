extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(_qwe):
	pass

func is_interactable(issuer):
	return issuer.holder_slot.get_child_count() > 0 \
		and issuer.holder_slot.get_child(0) is Item \
		and issuer.holder_slot.get_child(0).identifier == 'key'
