extends Node

var current_scene: Node = null
var _scene_stack: Array = []


func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)


func _open_eyes(scene):
	var player_vr: PlayerVR = Utils.find_child_with_type(scene, PlayerVR, true)
	if player_vr != null:
		player_vr.open_eyes()


func _close_eyes(scene):
	var player_vr: PlayerVR = Utils.find_child_with_type(scene, PlayerVR, true)
	if player_vr != null:
		await player_vr.close_eyes()


func load_scene(scene: PackedScene, context = null):
	assert(scene != null)
	if current_scene:
		await _close_eyes(current_scene)

	var scene_instance = scene.instantiate()

	if context != null:
		scene_instance.context = context

	_scene_stack.push_back(scene_instance)
	call_deferred("_add_scene", scene_instance)


func _add_scene(scene):
	get_tree().root.remove_child(current_scene)
	current_scene = scene
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	_open_eyes(current_scene)


func pop_scene():
	if current_scene:
		await _close_eyes(current_scene)
	call_deferred("_deferred_pop_scene")


func _deferred_pop_scene():
	var free_scene = _scene_stack.back()
	_scene_stack.pop_back()
	if _scene_stack.size():
		_add_scene(_scene_stack.back())

	if free_scene:
		free_scene.free()
