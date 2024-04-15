extends Interactable
class_name Shield



func get_interactable_root(): return self


func interact(issuer):
    if not issuer is Player: print('not player ', issuer);return;
    if issuer.holder_slot.get_child_count() == 0:
        var holder = get_interactable_root()
        holder.get_parent().remove_child(holder)
        issuer.holder_slot.add_child(holder)
        holder.position = Vector2.ZERO
        holder.rotation = 0
    else:
        print('drop it?')
        var pos = self.global_position
        var root = get_tree().root
        self.get_parent().remove_child(self)
        root.get_node('Simulation').add_child(self)
        self.global_position = pos

func is_interactable(issuer):
    return enabled and issuer.holder_slot.get_child_count() == 0 or issuer.holder_slot.get_child(0) is Shield

