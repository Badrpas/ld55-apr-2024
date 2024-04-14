extends Interactable
class_name Item


@export var identifier: String = 'unset'

var is_taken = false

func is_interactable(issuer):
    return enabled and not is_taken and issuer.holder_slot.get_child_count() == 0

func interact(issuer):
    if not issuer is Player: print('not player ', issuer);return;
    if is_interactable(issuer):
        var holder = get_interactable_root()
        holder.get_parent().remove_child(holder)
        issuer.holder_slot.add_child(holder)
        holder.position = Vector2.ZERO
        holder.rotation = 0
        is_taken = true
    else:
        print('not')
    






