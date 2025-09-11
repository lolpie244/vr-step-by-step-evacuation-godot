extends Node

var _scene_stack: Array
var current_scene = null

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func load_scene(scene: PackedScene, context = null):
	assert(scene != null)
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

func pop_scene():
	call_deferred("_deferred_pop_scene")

func _deferred_pop_scene():
	var free_scene = _scene_stack.back()
	_scene_stack.pop_back()
	if _scene_stack.size():
		_add_scene(_scene_stack.back())

	if free_scene:
		free_scene.free()
