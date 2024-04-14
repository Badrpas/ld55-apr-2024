extends Interactable
class_name Cauldron

@onready var BottleScene = preload('res://bottle.tscn')
@onready var aplayer: AnimationPlayer = $AnimationPlayer

var ingredients: Array[String] = []

var fired_up = false


func laddle_callback():
	print('not implemented cauldron result')
	var bottle = BottleScene.instantiate()
	bottle.position = self.global_position + Vector2(0, -50)
	bottle.ingredients.append_array(ingredients)
	ingredients.clear()
	get_tree().root.get_node('Simulation').add_child(bottle)
	var anim: Animation = aplayer.get_animation('bottle_pop')
	anim.track_set_path(0, String(bottle.get_path()) + ':position')
	anim.track_set_path(1, String(bottle.get_path()) + ':rotation')
	anim.track_set_path(2, String(bottle.get_path()) + ':enabled')
	aplayer.play('bottle_pop')

func get_interactable_root(): return self
func interact(issuer):
	if not is_interactable(issuer): return

	var item_handle = issuer.holder_slot.get_child(0)
	issuer.holder_slot.remove_child(item_handle)

	var item: Consumable = Interactable.FindInteractableIn(item_handle)
	ingredients.append(item.identifier)

	item_handle.free()

func is_interactable(issuer):
	return issuer.holder_slot.get_child_count() > 0 \
		and Interactable.FindInteractableIn(issuer.holder_slot.get_child(0)) is Consumable
