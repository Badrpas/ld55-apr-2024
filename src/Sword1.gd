extends Interactable
class_name Sword1


var is_taken = false


func is_interactable(issuer):
    return enabled and not is_taken and issuer.holder_slot.get_child_count() == 0

func interact(issuer):
    if not issuer is Player: print('not player ', issuer);return;
    $AnimationPlayer.stop(true)
    if is_interactable(issuer):
        var holder = get_interactable_root()
        holder.get_parent().remove_child(holder)
        issuer.holder_slot.add_child(holder)
        holder.position = Vector2.ZERO
        holder.rotation = PI
        is_taken = true
    else:
        print('not')
    


