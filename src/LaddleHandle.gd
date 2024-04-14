extends Interactable

@export var cauldron: Cauldron

@onready var laddle = $Handle/Laddle
@onready var aplayer: AnimationPlayer = $AnimationPlayer

func _ready():
	assert(cauldron)

func get_interactable_root(): return self
func interact(issuer):
	if not is_interactable(issuer): return
	# laddle.visible = false
	aplayer.play('mix')
	

func is_interactable(issuer):
	return not aplayer.is_playing() and issuer.holder_slot.get_child_count() == 0 and cauldron.ingredients.size() > 0
