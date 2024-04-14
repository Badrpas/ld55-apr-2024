extends Node

@onready var player: Player = $'..'
@onready var interaction_area = $'../Image/IteractionArea'

signal target_changed(target: Node2D)

var targets: Array[Node2D]
var current_target: Node2D = null

var interaction_marker = null
var __t = preload("res://assets/hand.png");

func _ready():
	assert(interaction_area)
	interaction_marker = Sprite2D.new()
	interaction_marker.z_index = 1000
	interaction_marker.scale = Vector2.ONE * 0.5
	interaction_marker.texture = __t
	interaction_marker.visible = false
	player.get_parent().add_child.call_deferred(interaction_marker)

	target_changed.connect(func (t): 
		interaction_marker.visible = not not t
		if t:
			print('targetting ', t)
			interaction_marker.position = t.global_position + Vector2(0, -70)
		else:
			print('cleared target ')
	)
	

@export var verbose = true

func add_potential_target(t: Node2D):
	var actual_target = _find_holder_target(t)
	if not actual_target: 
		if verbose: print('no actual target of ', t);
		return
	if targets.find(actual_target) > -1: 
		if verbose: print('already added', t, ' -> ', actual_target);
		return
	targets.append(actual_target)
	if verbose: print('appended ', t, ' -> ', actual_target)
	update_hovered()

func remove_potential_target(t: Node2D):
	var actual_target = _find_holder_target(t)
	if not actual_target: 
		if verbose: print('rem no actual target of ', t);
		return

	var idx = targets.find(actual_target);
	if idx > -1:
		targets.remove_at(idx)
		update_hovered()
		if verbose: print('removed ', t, ' -> ', actual_target)
	else:
		if verbose: print('already removed ', t, ' -> ', actual_target)
		pass


func _find_holder_target(t):
	return Interactable.FindHolderTarget(t)
	
func _find_interactable_in(t) -> Interactable:
	return Interactable.FindInteractableIn(t)



func _process(_delta):
	if current_target and Input.is_action_just_pressed('UseE'):
		var r = _find_interactable_in(current_target)
		if not r: return
		r.interact(player)
	update_hovered()

		

func update_hovered():
	if targets.size() == 0: 
		if current_target: 
			target_changed.emit(null)
		current_target = null
		return

	var m = 1.79769e308
	var t = null
	for target in targets:
		if not _find_interactable_in(target).is_interactable(player): continue
		var dist2 = target.global_position.distance_squared_to(interaction_area.global_position)
		if dist2 < m:
			m = dist2
			t = target

	if t != current_target:
		current_target = t
		target_changed.emit(current_target)



