extends Interactable

@onready var root: Hexagram = $'..'

func get_interactable_root(): return self
func interact(issuer):
	if not is_interactable(issuer): return

	var item_handle = issuer.holder_slot.get_child(0)
	issuer.holder_slot.remove_child(item_handle)

	var item: Bottle = Interactable.FindInteractableIn(item_handle)
	root.ingredients = item.ingredients

	item_handle.free()

	root.summon()



func is_interactable(issuer):
	if issuer.holder_slot.get_child_count() == 0: return false

	var item = Interactable.FindInteractableIn(issuer.holder_slot.get_child(0))
	return item \
		and item is Item \
		and item.identifier == 'bottle' 








