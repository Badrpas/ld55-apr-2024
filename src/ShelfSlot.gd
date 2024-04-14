extends Interactable


func get_interactable_root(): return self
func interact(issuer):
    if not is_interactable(issuer): return

    var item_handle = issuer.holder_slot.get_child(0)
    issuer.holder_slot.remove_child(item_handle)
    add_child(item_handle)
    item_handle.position.y = 0
    item_handle.position.x = 0

    var item = Interactable.FindInteractableIn(item_handle)
    item.is_taken = false

func is_interactable(issuer):
    if get_child_count() != 1: return false
    if issuer.holder_slot.get_child_count() == 0: return false

    var _item = Interactable.FindInteractableIn(issuer.holder_slot.get_child(0))
    if not _item is Item: return false

    var item: Item = _item
    if item.identifier == 'bottle': return false
    
    return true

