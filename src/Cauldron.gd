extends Interactable
class_name Cauldron

@onready var BottleScene = preload('res://bottle.tscn')
@onready var aplayer: AnimationPlayer = $AnimationPlayer

@onready var hint: Node2D = $hint_holder

var ingredients: Array[String] = []

var fired_up = false


func laddle_callback():
	print('not implemented cauldron result')
	var bottle = BottleScene.instantiate()
	bottle.position = self.global_position + Vector2(0, -50)
	bottle.ingredients.append_array(ingredients)
	ingredients.clear()
	get_tree().get_first_node_in_group("SIMULATION").add_child(bottle)
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
	if hint.visible: show_contents()

func is_interactable(issuer):
	return issuer.holder_slot.get_child_count() > 0 \
		and get_tree().get_nodes_in_group("bottles").size() < 1 \
		and Interactable.FindInteractableIn(issuer.holder_slot.get_child(0)) is Consumable


func _on_area_2d_area_entered(area:Area2D):
	if area.get_parent().get_parent() is Player: show_contents()
func on_exited(area):
	if area.get_parent().get_parent() is Player: hide_contents()

func show_contents():
	hint.visible = true
	while hint.get_child_count() > 0:
		var c = hint.get_child(0)
		hint.remove_child(c)
		c.free()

	var count = ingredients.size()
	for i in range(0, count):
		var ingr = ingredients[i]
		if not Recipe.ID_TO_IMG.has(ingr): continue
		var s: CompressedTexture2D = Recipe.ID_TO_IMG[ingr]
		if not s: continue;
		var n = Sprite2D.new()
		n.texture = s
		resize(n, 50)
		hint.add_child(n)
		if count > 1:
			n.position += Vector2(1,0) * ((count * 55.) / -2. + i * 55)

func hide_contents():
	hint.visible = false


func resize(s: Sprite2D, dimm: float):
	var size = s.texture.get_size()
	var k = maxf(size.x, size.y)
	s.scale /= k / dimm



