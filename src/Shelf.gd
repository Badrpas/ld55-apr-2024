extends Interactable

var max_items = 4
var slot_width = 52

@onready var slot: Node2D = $'slot_start'




func get_interactable_root(): return self
func interact(issuer):
    if not is_interactable(issuer): return
    var item_handle = issuer.holder_slot.get_child(0)
    issuer.holder_slot.remove_child(item_handle)
    slot.add_child(item_handle);
    item_handle.position.x = slot.get_child_count() * slot_width
    item_handle.position.y = 0
    var item = Interactable.FindInteractableIn(item_handle)
    item.is_taken = false

func is_interactable(issuer):
    return issuer.holder_slot.get_child_count() > 0 \
        and Interactable.FindInteractableIn(issuer.holder_slot.get_child(0)) is Item \
        and slot.get_child_count() < max_items


