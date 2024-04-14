extends Node
class_name Interactable


@export var override_root: Node2D = null
@export var enabled = true
	

func get_interactable_root():
	if override_root:
		return override_root
	return get_parent()

func is_interactable(_issuer):
	return true

func interact(issuer):
	print(self, ' not implemented interact() from ', issuer)




static func FindHolderTarget(t):
	if t.has_method('get_interactable_root'):
		return t.get_interactable_root()

	if t.get_parent().has_method('get_interactable_root'):
		return t.get_parent().get_interactable_root()

	for child in t.get_parent().get_children():
		if child.has_method('get_interactable_root'):
			return child.get_interactable_root()

	for child in t.get_children():
		if child.has_method('get_interactable_root'):
			return child.get_interactable_root()

	return null
	  
static func FindInteractableIn(t) -> Interactable:
	if t.has_method('get_interactable_root'): return t
	for child in t.get_children():
		if child.has_method('get_interactable_root'):
			return child
	return null

