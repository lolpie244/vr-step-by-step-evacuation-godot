extends Node

var current_scene: Node = null
var _scene_stack: Array = []


func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	_scene_stack.append(current_scene)


func _open_eyes():
	var player_vr: PlayerVR = Utils.find_child_with_type(current_scene, PlayerVR, true)
	if player_vr != null:
		player_vr.open_eyes()


func _close_eyes():
	var player_vr: PlayerVR = Utils.find_child_with_type(current_scene, PlayerVR, true)
	if player_vr != null:
		await player_vr.close_eyes()


func load_scene(scene: PackedScene, context = null):
	assert(scene != null)
	if current_scene:
		await _close_eyes()

	var scene_instance = scene.instantiate()

	if context != null:
		scene_instance.context = context

	_scene_stack.push_back(scene_instance)
	scene_instance.ready.connect(func(): call_deferred("_open_eyes"))

	call_deferred("_add_scene", scene_instance)


func _add_scene(scene):
	get_tree().root.remove_child.call_deferred(current_scene)
	current_scene = scene
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene


func pop_scene():
	if current_scene:
		await _close_eyes()
	call_deferred("_deferred_pop_scene")


func _deferred_pop_scene():
	var free_scene = _scene_stack.back()
	_scene_stack.pop_back()
	if _scene_stack.size():
		var scene = _scene_stack.back()
		_add_scene(scene)
		if scene.has_method("_enter_scene"):
			scene._enter_scene()

	_open_eyes()

	if free_scene:
		free_scene.free()


func replace_scene(scene: PackedScene, context = null):
	if _scene_stack.size():
		await _close_eyes()
		current_scene = null
		(
			(func(free_scene):
				if free_scene:
					free_scene.free())
			. call_deferred(_scene_stack.pop_back())
		)
	load_scene(scene, context)
