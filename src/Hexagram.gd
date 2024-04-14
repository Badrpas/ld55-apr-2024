extends Node2D
class_name Hexagram

@onready var fire: Sprite2D = $Fire
@onready var slots: Node2D = $slots
@onready var aplayer: AnimationPlayer = $AnimationPlayer
@onready var center: Node2D = $center

var ingredients: Array[String] = []

static var Recipes: Array[Recipe] = []

func _ready():
    Recipes = Recipe.GetList()

func summon():
    aplayer.play('flicker')
    

func _summon():
    var target_recipe: Recipe
    for recipe in Recipes:
        var cata_ok = true
        for reagent in recipe.catalyst:
            if not ingredients.has(reagent): cata_ok = false; break
        if not cata_ok: continue;

        var items_ok = true
        for req_item in recipe.items:
            var item_found = false
            for slot in slots.get_children():
                var item: Interactable = _get_item_from_slot(slot)
                if not item: continue;
                if item.identifier == req_item: item_found = true; break
            if not item_found: items_ok = false; break
        if not items_ok: continue;

        target_recipe = recipe
        break

    print('foun recipe ', target_recipe)

    fire.visible = not not target_recipe
    if not target_recipe: return
    
    var summoned = target_recipe.result.instantiate()
    get_tree().root.get_node('Simulation').add_child(summoned)
    summoned.position = center.global_position








func _get_item_from_slot(slot: Node2D) -> Interactable:
    for child in slot.get_children():
        var i = Interactable.FindInteractableIn(child)
        if i: return i
    return null
