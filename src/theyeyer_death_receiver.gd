extends Interactable





func die():
    var root = $".."
    root.tween.stop()
    if root.spot_tween: root.spot_tween.stop()
    # $"../AudioStreamPlayerLoop".stop()
    $"../AudioStreamPlayerPrepare".stop()
    root.dead = true
    $"../AnimationPlayer".play('death')
    get_tree().get_first_node_in_group('SWORD1').enabled = false
    $"../Sprite".z_index = root.global_position.y
    


func interact(issuer):
    var sword = issuer.holder_slot.get_child(0)
    issuer.holder_slot.remove_child(sword)
    $"../Sprite".add_child(sword)
    sword.position = Vector2(-160, -46)
    sword.rotation = PI / -2
    sword.z_index = -1
    die()


func is_interactable(issuer):
    if $"..".dead: return false
    if issuer.holder_slot.get_child_count() == 0: return false
    return issuer.holder_slot.get_child(0) is Sword1


