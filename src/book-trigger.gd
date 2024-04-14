extends Interactable


@onready var cam: Camera2D = $'../Cam'
@onready var vtarget: Node2D = $cam_target
@onready var items: Node2D = $cam_target/items
@onready var reagents: Node2D = $cam_target/reagents
@onready var result: Node2D = $cam_target/result

var idx = 0;

var locked = false
var last_target

func _ready():
	assert(cam)
	assert(vtarget)
	vtarget.visible = false

func interact(issuer):
	if not locked:
		last_target = cam.target
		cam.target = vtarget
		issuer.get_node('controller').enabled = false
		locked = true
		upd_recipes()
	else:
		cam.target = last_target
		issuer.get_node('controller').enabled = true
		locked = false
	vtarget.visible = locked


func _process(delta):
	if not locked: return

	if Input.is_action_just_pressed('right'):
		idx += 1;
		idx = idx % Hexagram.Recipes.size()
		upd_recipes()
	if Input.is_action_just_pressed('left'):
		idx -= 1 - Hexagram.Recipes.size();
		idx = idx % Hexagram.Recipes.size()
		upd_recipes()

func upd_recipes():
	while items.get_child_count() > 0:
		var c = items.get_child(0)
		items.remove_child(c)
		c.free()
	while reagents.get_child_count() > 0:
		var c = reagents.get_child(0)
		reagents.remove_child(c)
		c.free()
	while result.get_child_count() > 0:
		var c = result.get_child(0)
		result.remove_child(c)
		c.free()
	

	var recipe = Hexagram.Recipes[idx % Hexagram.Recipes.size()]

	for req_item in recipe.items:
		if not Recipe.ID_TO_IMG.has(req_item): continue
		var s: CompressedTexture2D = Recipe.ID_TO_IMG[req_item]
		if not s: continue;
		var n = Sprite2D.new()
		n.texture = s
		resize(n, 160)
		items.add_child(n)
	
	for req_cata in recipe.catalyst:
		if not Recipe.ID_TO_IMG.has(req_cata): continue
		var s: CompressedTexture2D = Recipe.ID_TO_IMG[req_cata]
		if not s: continue;
		var n = Sprite2D.new()
		n.texture = s
		resize(n, 160)
		reagents.add_child(n)
		
	if Recipe.ID_TO_IMG.has(recipe.result_id):
		var s: CompressedTexture2D = Recipe.ID_TO_IMG[recipe.result_id]
		if s: 
			var n = Sprite2D.new()
			n.texture = s
			resize(n, 160)
			result.add_child(n)
		

func resize(s: Sprite2D, dimm: float):
	var size = s.texture.get_size()
	var k = maxf(size.x, size.y)
	s.scale /= k / dimm
	print(s, ' size ', s.texture.get_size(), ' bruh ', s.scale)
	


